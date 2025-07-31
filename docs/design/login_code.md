<!DOCTYPE html>
<html lang="ru"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>BizLevel Login</title>
<link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;700;800&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"/>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<style type="text/tailwindcss">
        body {
            font-family: 'Manrope', sans-serif;
        }
    </style>
</head>
<body class="bg-gray-100">
<div class="min-h-screen flex flex-col items-center justify-center relative py-12 px-4 sm:px-6 lg:px-8">
<div class="absolute inset-0 bg-gradient-to-br from-blue-50 to-indigo-100 -z-10"></div>
<div class="text-center mb-8">
<div class="flex justify-center items-center mb-4">
<div class="bg-white p-4 rounded-full shadow-lg">
<div class="bg-blue-100 p-3 rounded-full">
<svg class="w-10 h-10 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.539 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.196-1.539-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.783-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"></path></svg>
</div>
</div>
</div>
<h1 class="text-4xl font-extrabold text-gray-900 tracking-tight">BizLevel</h1>
<p class="mt-2 text-lg text-gray-600">Ваш путь к бизнес-успеху начинается здесь</p>
</div>
<div class="w-full max-w-md bg-white p-8 rounded-2xl shadow-2xl">
<form action="#" class="space-y-6" method="POST">
<div>
<div class="relative">
<span class="absolute inset-y-0 left-0 flex items-center pl-3">
<span class="material-icons text-gray-400">mail_outline</span>
</span>
<input autocomplete="email" class="block w-full pl-10 pr-3 py-3 border border-gray-200 rounded-xl placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 focus:border-blue-500 sm:text-sm shadow-inner" id="email" name="email" placeholder="Email" required="" type="email"/>
</div>
</div>
<div>
<div class="relative">
<span class="absolute inset-y-0 left-0 flex items-center pl-3">
<span class="material-icons text-gray-400">lock_outline</span>
</span>
<input autocomplete="current-password" class="block w-full pl-10 pr-3 py-3 border border-gray-200 rounded-xl placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 focus:border-blue-500 sm:text-sm shadow-inner" id="password" name="password" placeholder="Пароль" required="" type="password"/>
</div>
</div>
<div>
<button class="w-full flex justify-center py-3 px-4 border border-transparent rounded-xl shadow-lg text-sm font-medium text-white bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transform hover:scale-105 transition-transform duration-200" type="submit">
                        Войти
                    </button>
</div>
</form>
<div class="mt-6 text-center">
<p class="text-sm text-gray-600">
                    Нет аккаунта?
                    <a class="font-medium text-blue-600 hover:text-blue-500" href="#">
                        Зарегистрироваться
                    </a>
</p>
</div>
</div>
</div>

</body></html>