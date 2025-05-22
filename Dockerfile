# Используем официальный образ PHP-FPM на основе Debian
FROM php:8.2-fpm

# Устанавливаем зависимости
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    libxml2-dev \
    libonig-dev \
    curl \
    git \
    supervisor \
    && rm -rf /var/lib/apt/lists/*
    # Устанавливаем зависимости для Redis
RUN apt-get update && apt-get install -y \
    libhiredis-dev \
    && rm -rf /var/lib/apt/lists/*

# Устанавливаем расширение Redis
# RUN pecl install redis \
#     && docker-php-ext-enable redis
# Устанавливаем расширения PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    gd \
    intl \
    mbstring \
    mysqli \
    opcache \
    pdo_mysql \
    xml \
    zip \
    sockets

# Устанавливаем Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Настраиваем PHP для MediaWiki
# RUN { \
#     echo 'opcache.memory_consumption=128'; \
#     echo 'opcache.interned_strings_buffer=8'; \
#     echo 'opcache.max_accelerated_files=4000'; \
#     echo 'opcache.revalidate_freq=60'; \
#     echo 'opcache.fast_shutdown=1'; \
#     echo 'opcache.enable_cli=1'; \
#     echo 'upload_max_filesize=100M'; \
#     echo 'post_max_size=100M'; \
#     echo 'memory_limit=256M'; \
#     echo 'max_execution_time=300'; \
#
# } > /usr/local/etc/php/conf.d/mediawiki.ini

# echo 'session.save_handler = redis'; \
# echo 'session.save_path = "tcp://172.16.1.246:6379?auth=redispass"'; \
# Создаем пользователя и группу для MediaWiki
RUN groupadd -g 1000 mediawiki && \
    useradd -u 1000 -g mediawiki -d /var/www/wiki -s /bin/bash mediawiki

# Рабочая директория
WORKDIR /var/www/wiki

# Меняем владельца файлов
RUN chown -R mediawiki:mediawiki /var/www/wiki

# Переключаемся на пользователя mediawiki
USER mediawiki

# Указываем, что контейнер слушает порт 9000
EXPOSE 9000

# Команда для запуска PHP-FPM
CMD ["php-fpm"]
