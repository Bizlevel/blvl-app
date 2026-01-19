## Sentry Alerts and Validation Checklist (Mobile)

### Alerts (set in Sentry UI)
- [ ] New issue in `environment:prod`
- [ ] Error spike in `environment:prod`
- [ ] High user impact (userCount > 10) in `environment:prod`

### Manual validation (iOS/Android)
- [ ] Login success and failure (email/password)
- [ ] Google Sign-In cancel and success
- [ ] Logout flow
- [ ] Deep link to `/levels/:id` and `/case/:id`
- [ ] Open Mentors, open existing chat, start new chat
- [ ] Send message in Leo/Max chat (success + simulated failure)
- [ ] Open Profile, update About Me, change avatar
- [ ] Open Library, open section, filter category, toggle favorite, open link
- [ ] Push tap opens expected route

### Verification in Sentry
- [ ] Breadcrumbs appear for each step above
- [ ] User context present after auto-login
- [ ] No user text leaks in breadcrumb data
- [ ] Release shown and symbols available for latest build
