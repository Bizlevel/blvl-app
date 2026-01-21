-- Fix get_referral_code to use pgcrypto in extensions schema
create or replace function public.get_referral_code()
returns text
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  v_user uuid := auth.uid();
  v_code text;
  v_attempts int := 0;
begin
  if v_user is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  select code into v_code
  from public.referral_codes
  where user_id = v_user;

  if v_code is not null then
    return v_code;
  end if;

  loop
    v_code := 'BZ' || upper(encode(gen_random_bytes(4), 'hex'));
    begin
      insert into public.referral_codes(user_id, code)
      values (v_user, v_code);
      return v_code;
    exception when unique_violation then
      v_attempts := v_attempts + 1;
      if v_attempts > 5 then
        raise exception 'referral_code_generation_failed';
      end if;
      select code into v_code
      from public.referral_codes
      where user_id = v_user;
      if v_code is not null then
        return v_code;
      end if;
    end;
  end loop;
end;
$$;
