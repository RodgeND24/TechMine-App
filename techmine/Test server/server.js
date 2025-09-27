const express = require('express');
const path = require('path');
const compression = require('compression');
const helmet = require('helmet');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;
const BUILD_PATH = path.join(__dirname, '../build/web');

// Middleware
app.use(compression()); // Gzip сжатие
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'", "'unsafe-inline'", "'unsafe-eval'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", "data:", "blob:"],
      connectSrc: ["'self'", "blob:"],
    },
  },
  crossOriginEmbedderPolicy: false
}));
app.use(cors());

// Статические файлы
app.use(express.static(BUILD_PATH, {
  etag: true,
  lastModified: true,
  maxAge: '1d',
  setHeaders: (res, path) => {
    // Кэширование для статических файлов
    if (path.match(/\.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$/)) {
      res.setHeader('Cache-Control', 'public, max-age=31536000, immutable');
    }
  }
}));

// Логирование запросов
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.url} - ${req.ip}`);
  next();
});

// Обработка всех маршрутов для SPA
app.get('*', (req, res) => {
  // Проверяем, существует ли запрашиваемый файл
  const filePath = path.join(BUILD_PATH, req.path);
  
  // Если запрашивается файл с расширением и он существует - отдаем его
  if (req.path.match(/\.[a-zA-Z0-9]+$/) && require('fs').existsSync(filePath)) {
    return res.sendFile(filePath);
  }
  
  // Иначе отдаем index.html для клиентской маршрутизации
  res.sendFile(path.join(BUILD_PATH, 'index.html'));
});

// Обработка ошибок
app.use((err, req, res, next) => {
  console.error('Error:', err.stack);
  res.status(500).send('Something broke!');
});

// Запуск сервера
app.listen(PORT, '0.0.0.0', () => {
  console.log(`
🚀 Flutter SPA Server запущен!
📍 Локальный: http://localhost:${PORT}
🌐 Сеть: http://0.0.0.0:${PORT}

📁 Обслуживается из: ${BUILD_PATH}
⏰ Время запуска: ${new Date().toLocaleString()}
  `);
});

// Graceful shutdown
process.on('SIGINT', () => {
  console.log('\n🛑 Сервер останавливается...');
  process.exit(0);
});

process.on('SIGTERM', () => {
  console.log('\n🛑 Сервер получает SIGTERM...');
  process.exit(0);
});