# Laravel + Vue.js Setup Script with Vite & Tailwind CSS

This script automates the setup of a new Laravel project integrated with pure Vue.js (v3), Vite (as the bundler), and Tailwind CSS for styling. It's designed for developers who want a manual, scaffold-free setup without using Laravel Breeze, Jetstream, or Inertia.js.

## Features
- Creates a fresh Laravel project.
- Installs Vue.js 3 and the Vite Vue plugin (compatible with Vite 7).
- Configures Vite for hot module replacement (HMR).
- Sets up Tailwind CSS v3 with PostCSS and Autoprefixer (avoids v4 init issues).
- Includes a root `App.vue` component with a simple interactive counter demo styled with Tailwind.
- Updates the default welcome page to mount the Vue app.

## Prerequisites
- PHP 8.2+ with Composer.
- Node.js 18+ with npm.
- Git (optional, for repo management).
- `curl` and `bash` (for direct script execution).

## Usage
You can run the script directly from GitHub without downloading it (one-liner), or download it first for more control.

### Option 1: Direct Execution (No Download)
Run the script directly via curl and pipe to bash (includes the project name, optional Laravel port, and optional Vite port):

```bash
curl -s https://raw.githubusercontent.com/Urani-Solutions/laravel-vuejs-setup/refs/heads/main/create_laravel_vuejs.sh | bash -s my-project
```
- Arguments: `<project-name> [laravel-port] [vite-port]`
  - Defaults: `my-laravel-vue-app`
- **Note**: This is convenient but less secure—review the script source first if concerned.

### Option 2: Download and Run (Safer for Review)
1. Download the script:
   ```bash
   curl -O https://raw.githubusercontent.com/Urani-Solutions/laravel-vuejs-setup/refs/heads/main/create_laravel_vuejs.sh
   ```

2. Run the script with arguments:
   ```bash
   ./setup-laravel-vue.sh my-project
   ```
   - Defaults to `my-laravel-vue-app` (project), `8000` (Laravel port), `5173` (Vite port) if not provided.

3. Follow the on-screen instructions:
   - The script will create the project and configure everything.
   - Start the Laravel dev server: `php artisan serve --port=8000`.
   - In a new terminal, build/watch assets: `npm run dev -- --port=5173`.
   - Open [http://127.0.0.1:8000](http://127.0.0.1:8000) to see the Vue app in action.

For production:
```bash
npm run build
```

## Project Structure (After Setup)
The script generates a standard Laravel structure with the following key additions/modifications for Vue.js, Vite, and Tailwind:

```
my-laravel-vue-app/
├── app/                     # Laravel app logic (controllers, models, etc.)
├── bootstrap/               # Laravel bootstrap files
├── config/                  # Laravel config
├── database/                # Migrations, factories, seeders
├── public/                  # Public assets (index.php, etc.)
├── resources/
│   ├── css/
│   │   └── app.css          # Tailwind directives (@tailwind base; etc.)
│   ├── js/
│   │   ├── app.js           # Vue app entry point (imports App.vue)
│   │   ├── App.vue          # Root Vue component (counter demo with Tailwind)
│   │   └── bootstrap.js     # Laravel JS bootstrap (Axios, etc.)
│   └── views/
│       └── welcome.blade.php # Mounts Vue app (#app div with @vite)
├── routes/                  # Routes (web.php, etc.)
├── storage/                 # Logs, framework cache
├── tailwind.config.js       # Tailwind config (content paths for Blade/JS/Vue)
├── vite.config.js           # Vite config (Laravel + Vue plugins)
├── package.json             # Node dependencies (Vue, Tailwind, etc.)
├── postcss.config.js        # PostCSS config (for Tailwind)
├── composer.json            # PHP dependencies
└── ... (other standard Laravel files)
```

## Customization
- **Vue Components**: Add more components in `resources/js/` and import them in `app.js`.
- **Tailwind**: Extend `tailwind.config.js` for custom themes.
- **Routes**: Update `routes/web.php` to render other Blade views with Vue mounts.

## Troubleshooting
- **npm errors**: Ensure Node.js is up-to-date; clear cache with `npm cache clean --force`.
- **Composer issues**: Run `composer install` manually if needed.
- **Vite HMR not working**: Check `npm run dev` output for errors.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing
Feel free to fork, improve, and submit pull requests! Contributors include:
- Urani Solutions

---

⭐ Star this repo if it helps you get started quickly!
