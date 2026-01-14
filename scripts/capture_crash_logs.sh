#!/bin/bash
# Скрипт для захвата логов при вылете приложения

echo "Очищаем старые логи..."
adb logcat -c

echo "Захватываем логи (нажмите Ctrl+C для остановки)..."
echo "Логи сохраняются в crash_logs_$(date +%Y%m%d_%H%M%S).txt"
echo ""

# Захватываем все логи и фильтруем важные
adb logcat -v time | tee "crash_logs_$(date +%Y%m%d_%H%M%S).txt" | grep -E "(flutter|dart|FATAL|AndroidRuntime|LEO_DIALOG|crash|exception|Error|ERROR|W/Flutter|E/Flutter)" --line-buffered --color=always
