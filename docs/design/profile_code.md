<!DOCTYPE html>
<html lang="ru"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Профиль</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"/>
<style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #F8F7FA;
        }
    </style>
</head>
<body class="bg-gray-50 text-gray-800">
<div class="flex h-screen">
<aside class="w-64 bg-white p-6 flex flex-col justify-between border-r border-gray-200">
<div>
<div class="flex items-center space-x-4 mb-8">
<div class="w-10 h-10 rounded-full bg-gray-200 flex items-center justify-center font-bold text-gray-500">
                    Е
                </div>
<span class="font-semibold text-lg">Ерлан</span>
</div>
<div class="mb-8">
<p class="text-sm text-gray-500 mb-2">Ты на 6 уровне!</p>
<div class="w-full bg-gray-200 rounded-full h-2.5">
<div class="bg-yellow-400 h-2.5 rounded-full" style="width: 75%"></div>
</div>
</div>
<nav>
<ul>
<li>
<a class="flex items-center p-3 text-gray-500 hover:bg-gray-100 rounded-lg" href="#">
<span class="material-icons">map</span>
<span class="ml-3">Карта уровней</span>
</a>
</li>
<li>
<a class="flex items-center p-3 text-gray-500 hover:bg-gray-100 rounded-lg" href="#">
<span class="material-icons">chat_bubble_outline</span>
<span class="ml-3">Чат с Лео</span>
</a>
</li>
<li>
<a class="flex items-center p-3 bg-blue-100 text-blue-600 rounded-lg" href="#">
<span class="material-icons">person_outline</span>
<span class="ml-3 font-semibold">Профиль</span>
</a>
</li>
</ul>
</nav>
</div>
</aside>
<main class="flex-1 p-6 overflow-y-auto">
<section class="bg-white p-4 rounded-2xl shadow-sm flex items-center mb-6">
<div class="w-20 h-20 rounded-full bg-gray-200 flex items-center justify-center font-bold text-gray-500 text-3xl mr-4">
                Е
            </div>
<div>
<div class="flex items-center mb-1">
<h2 class="text-xl font-bold mr-3">Ерлан</h2>
<span class="bg-gradient-to-r from-yellow-400 to-amber-500 text-white text-xs font-semibold px-3 py-1 rounded-full">Premium</span>
</div>
<p class="text-gray-500 text-sm">Отличный прогресс в обучении!</p>
</div>
</section>
<div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
<div class="bg-white p-4 rounded-2xl shadow-sm flex flex-col items-center justify-center border-t-4 border-green-500">
<div class="flex items-center">
<span class="material-icons text-green-500 mr-2">school</span>
<span class="font-bold text-base">5 Уровень</span>
<span class="material-icons text-green-500 ml-2">check_circle</span>
</div>
</div>
<div class="bg-white p-4 rounded-2xl shadow-sm flex flex-col items-center justify-center border-t-4 border-blue-500">
<div class="flex items-center">
<span class="material-icons text-blue-500 mr-2">chat_bubble</span>
<span class="font-bold text-base">29 Сообщений Leo</span>
</div>
</div>
<div class="bg-white p-4 rounded-2xl shadow-sm flex flex-col items-center justify-center border-t-4 border-yellow-400">
<div class="flex items-center">
<span class="material-icons text-yellow-500 mr-2">emoji_events</span>
<span class="font-bold text-base">4 Артефакта</span>
</div>
</div>
</div>
<div class="space-y-3 mb-6">
<div class="bg-white p-3 rounded-2xl shadow-sm flex justify-between items-center cursor-pointer hover:bg-gray-50">
<div class="flex items-center">
<span class="material-icons mr-3 text-xl">settings</span>
<span class="font-semibold text-sm">Настройки</span>
</div>
<span class="material-icons text-gray-400">chevron_right</span>
</div>
<div class="bg-white p-3 rounded-2xl shadow-sm flex justify-between items-center cursor-pointer hover:bg-gray-50">
<div class="flex items-center">
<span class="material-icons mr-3 text-xl">payment</span>
<span class="font-semibold text-sm">Платежи</span>
</div>
<span class="material-icons text-gray-400">chevron_right</span>
</div>
<div class="bg-white p-3 rounded-2xl shadow-sm flex justify-between items-center cursor-pointer hover:bg-gray-50">
<div class="flex items-center">
<span class="material-icons mr-3 text-xl">exit_to_app</span>
<span class="font-semibold text-sm">Выход</span>
</div>
<span class="material-icons text-gray-400">chevron_right</span>
</div>
</div>
<section>
<h2 class="text-xl font-bold mb-4">Артефакты</h2>
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
<div class="bg-white p-4 rounded-2xl shadow-sm flex items-center justify-between">
<div class="flex items-center">
<img alt="Artifact thumbnail" class="w-16 h-16 rounded-lg mr-4 object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBxigk25Pv0pfnt86dka5nG9W48mG1h6El4-t5PcL0kCoHJH0g0-V7RiaiqC-FxBZfjdcUoISWQx-GR6XQZ34BBdWYJd7mZ5VJ4FB86f1VHTsXwPe-070D4JbxRTS3U_pOpMvISFqrxh6x8vQd0ETpYcWgA-UwJ8uLRSnI6FqyIJas5diCwcyGWh5L1GKmz4HOyPjWvgJFvLk8avJPYs7_mI1l9EBBQBymO7ccH8oaXcuoEx4fgg3jWluQ3XHOZaeyi01P2nqqCAqhS"/>
<div>
<h4 class="font-semibold">SMART-шаблон целей</h4>
<p class="text-sm text-gray-500">Level 3</p>
</div>
</div>
<button class="p-2 rounded-full hover:bg-gray-100">
<span class="material-icons text-gray-500">download</span>
</button>
</div>
<div class="bg-white p-4 rounded-2xl shadow-sm flex items-center justify-between">
<div class="flex items-center">
<img alt="Artifact thumbnail" class="w-16 h-16 rounded-lg mr-4 object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCUU1qG1jpYjG1fjcll0BZPEWlpuin39enN8f3oruZKkAgOV8pZZ-Hj6gICMp4SdSx5RyT2TI1vIva0sCAFBtLMV57WLhXBqXq0uI2AVYIaa7HjTs2EvFZCija4LPhvHklUNvBrb8ttoZnib08X1HSnySC7xqitg-6Y_dqD91-VtbrtxyviSXHNVzuglIhY2ZwRDUUU-BWV8MOlxLaNmYNmLinzkeSAcwlLlDvNR8cXDTZEnEPzIdmj4SDprKLPndslrkSi0Yg2xJEC"/>
<div>
<h4 class="font-semibold">План управления стрессом</h4>
<p class="text-sm text-gray-500">Level 4</p>
</div>
</div>
<button class="p-2 rounded-full hover:bg-gray-100">
<span class="material-icons text-gray-500">download</span>
</button>
</div>
<div class="bg-white p-4 rounded-2xl shadow-sm flex items-center justify-between">
<div class="flex items-center">
<img alt="Artifact thumbnail" class="w-16 h-16 rounded-lg mr-4 object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAj6OrJB_1rEiMz-rOcBLhMBLEl26VR3Ap9p2YosDtY-dg3Tua17lGrPL59rKlcNhX0E6j9z69bjRwviT9mi4nRcla5YRsJJtq2AinA-K4DQp3aQv55_Qd8vin7W0pTsMzWIxkD_jzHsRkviBRWw-efLy5-kZPMxXjoINRLBZbg1IG8b2an4j6oFxSSXkU_cv7DDPyS-SdEPuMtRNarVMAHjBm_RG69u61PmizsHZxmawmy0mBJX-Wt3EDa3jzSX-W1MWsDzvLHUho9"/>
<div>
<h4 class="font-semibold">Интерактивная матрица</h4>
<p class="text-sm text-gray-500">Level 5</p>
</div>
</div>
<button class="p-2 rounded-full hover:bg-gray-100">
<span class="material-icons text-gray-500">download</span>
</button>
</div>
<div class="bg-white p-4 rounded-2xl shadow-sm flex items-center justify-between">
<div class="flex items-center">
<img alt="Artifact thumbnail" class="w-16 h-16 rounded-lg mr-4 object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAPMNfvDaHcw1e63XrtVOEExOQUgMEh0wH-FJ8hc1nK2KlTDu3BRVY__JWWIftHJ6ZHBRJ2bfTnChxAqSmWkEcPoHs93u29wvGkohy5c-n9rw2YXkE6uoIhJU82r6vtutSLFwBL6dW7alVKvULoj5jX7sNgmVDBkIqB3Qeo21wifPgLjNnbgYSk8OLQpc6OF6iM5YkxWWI9TliUe4HUxTzIMT67u_yg_0x0FFfzNA5RfX-plzdai6V3OJnW7Q7h66gtt0CS4Jg6ZfMZ"/>
<div>
<h4 class="font-semibold">Шаблон OKR</h4>
<p class="text-sm text-gray-500">Level 6</p>
</div>
</div>
<button class="p-2 rounded-full hover:bg-gray-100">
<span class="material-icons text-gray-500">download</span>
</button>
</div>
<div class="bg-white p-4 rounded-2xl shadow-sm flex items-center justify-between">
<div class="flex items-center">
<img alt="Artifact thumbnail" class="w-16 h-16 rounded-lg mr-4 object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBxigk25Pv0pfnt86dka5nG9W48mG1h6El4-t5PcL0kCoHJH0g0-V7RiaiqC-FxBZfjdcUoISWQx-GR6XQZ34BBdWYJd7mZ5VJ4FB86f1VHTsXwPe-070D4JbxRTS3U_pOpMvISFqrxh6x8vQd0ETpYcWgA-UwJ8uLRSnI6FqyIJas5diCwcyGWh5L1GKmz4HOyPjWvgJFvLk8avJPYs7_mI1l9EBBQBymO7ccH8oaXcuoEx4fgg3jWluQ3XHOZaeyi01P2nqqCAqhS"/>
<div>
<h4 class="font-semibold">Пример артефакта 5</h4>
<p class="text-sm text-gray-500">Level 7</p>
</div>
</div>
<button class="p-2 rounded-full hover:bg-gray-100">
<span class="material-icons text-gray-500">download</span>
</button>
</div>
<div class="bg-white p-4 rounded-2xl shadow-sm flex items-center justify-between">
<div class="flex items-center">
<img alt="Artifact thumbnail" class="w-16 h-16 rounded-lg mr-4 object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCUU1qG1jpYjG1fjcll0BZPEWlpuin39enN8f3oruZKkAgOV8pZZ-Hj6gICMp4SdSx5RyT2TI1vIva0sCAFBtLMV57WLhXBqXq0uI2AVYIaa7HjTs2EvFZCija4LPhvHklUNvBrb8ttoZnib08X1HSnySC7xqitg-6Y_dqD91-VtbrtxyviSXHNVzuglIhY2ZwRDUUU-BWV8MOlxLaNmYNmLinzkeSAcwlLlDvNR8cXDTZEnEPzIdmj4SDprKLPndslrkSi0Yg2xJEC"/>
<div>
<h4 class="font-semibold">Пример артефакта 6</h4>
<p class="text-sm text-gray-500">Level 8</p>
</div>
</div>
<button class="p-2 rounded-full hover:bg-gray-100">
<span class="material-icons text-gray-500">download</span>
</button>
</div>
</div>
</section>
</main>
</div>
</body></html>