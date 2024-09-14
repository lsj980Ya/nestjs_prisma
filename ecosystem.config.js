module.exports = {
  apps: [
    {
      name: 'nestjs-app', // 应用名称
      script: 'dist/main.js', // 启动脚本
      instances: 'max', // 最大实例数
      exec_mode: 'cluster', // 使用集群模式
      watch: false, // 关闭文件监控
      max_memory_restart: '1G', // 内存超限自动重启
      env: {
        NODE_ENV: 'development',
      },
      env_production: {
        NODE_ENV: 'production',
      },
    },
  ],
};
