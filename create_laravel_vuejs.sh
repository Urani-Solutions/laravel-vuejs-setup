#!/bin/bash

# Laravel + Pure Vue.js Setup Script with Vite and Tailwind CSS
# This script creates a new Laravel project and sets up Vue.js with Vite and Tailwind CSS manually (no scaffolds like Breeze or Inertia).
# Prerequisites: Composer, Node.js/npm, and PHP must be installed.
# Usage: ./setup-laravel-vue.sh <project-name>

set -e  # Exit on any error

PROJECT_NAME=${1:-my-laravel-vue-app}
echo "Creating Laravel project: $PROJECT_NAME"

# Step 1: Create a new Laravel project
composer create-project laravel/laravel "$PROJECT_NAME"
cd "$PROJECT_NAME"

echo "Laravel project created. Installing Vue.js dependencies..."

# Step 2: Install Vue.js and Vite plugin for Vue
npm install vue@^3.5.0 @vitejs/plugin-vue@^6.0.0 --save-dev

echo "Vue dependencies installed. Installing Tailwind CSS..."

# Step 3: Install Tailwind CSS
npm install -D tailwindcss@^3.4.14 postcss autoprefixer
npx tailwindcss init -p

echo "Tailwind installed. Configuring Tailwind..."

# Step 4: Update tailwind.config.js
cat > tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./resources/**/*.blade.php",
    "./resources/**/*.js",
    "./resources/**/*.vue",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF

echo "Tailwind config updated. Adding Tailwind directives to CSS..."

# Step 5: Update resources/css/app.css
cat > resources/css/app.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

echo "CSS updated. Updating Vite config..."

# Step 6: Update vite.config.js to include Vue plugin
cat > vite.config.js << 'EOF'
import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import vue from '@vitejs/plugin-vue';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
        }),
        vue({
            template: {
                transformAssetUrls: {
                    base: null,
                    includeAbsolute: false,
                },
            },
        }),
    ],
});
EOF

echo "Vite config updated. Setting up app.js..."

# Step 7: Update resources/js/app.js for Vue with root App component
cat > resources/js/app.js << 'EOF'
import './bootstrap';
import { createApp } from 'vue';
import App from './App.vue';

const app = createApp(App);
app.mount('#app');
EOF

echo "app.js updated. Creating root App.vue component with Tailwind..."

# Step 8: Create root App.vue component with Tailwind classes
cat > resources/js/App.vue << 'EOF'
<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full space-y-8">
      <div>
        <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
          {{ msg }}
        </h2>
        <p class="mt-2 text-center text-sm text-gray-600">
          Current count is {{ count }}
        </p>
      </div>
      <div>
        <button
          @click="count++"
          class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
        >
          Click me
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      msg: 'Hello Vue in Laravel!',
      count: 0
    }
  }
}
</script>
EOF

echo "App.vue created. Updating welcome blade template..."

# Step 9: Update resources/views/welcome.blade.php to mount Vue app
cat > resources/views/welcome.blade.php << 'EOF'
<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Laravel + Vue + Tailwind</title>
        @vite(['resources/css/app.css', 'resources/js/app.js'])
    </head>
    <body class="antialiased bg-gray-50">
        <div id="app"></div>
    </body>
</html>
EOF

echo "Setup complete!"
echo "To run the project:"
echo "  - Start the dev server: php artisan serve"
echo "  - In a new terminal, run: npm run dev"
echo "  - Visit http://127.0.0.1:8000"
echo "  - For production build: npm run build"
echo ""
# Optional Docker setup
read -p "Do you want to download Docker configuration files (nginx, php, db, supervisord, .env) to run the project with Docker? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Downloading Docker files..."
  curl -s -o .env https://raw.githubusercontent.com/Urani-Solutions/laravel-vuejs-setup/main/.env
  curl -s -o Dockerfile https://raw.githubusercontent.com/Urani-Solutions/laravel-vuejs-setup/main/Dockerfile
  curl -s -o docker-compose.yml https://raw.githubusercontent.com/Urani-Solutions/laravel-vuejs-setup/main/docker-compose.yml
  curl -s -o supervisord.conf https://raw.githubusercontent.com/Urani-Solutions/laravel-vuejs-setup/main/supervisord.conf
  mkdir -p docker/nginx docker/php
  curl -s -o docker/nginx/app.conf https://raw.githubusercontent.com/Urani-Solutions/laravel-vuejs-setup/main/docker/nginx/app.conf
  curl -s -o docker/nginx/Dockerfile https://raw.githubusercontent.com/Urani-Solutions/laravel-vuejs-setup/main/docker/nginx/Dockerfile
  curl -s -o docker/php/local.ini https://raw.githubusercontent.com/Urani-Solutions/laravel-vuejs-setup/main/docker/php/local.ini
  curl -s -o docker/php/www.conf https://raw.githubusercontent.com/Urani-Solutions/laravel-vuejs-setup/main/docker/php/www.conf
  echo "Docker configuration downloaded to $(pwd)."
  echo "To run with Docker:"
  echo "  - Copy .env.example to .env and configure as needed"
  echo "  - Run: docker-compose up -d"
  echo "  - Access at http://localhost:9000"
fi

echo "Project directory: $(pwd)"
