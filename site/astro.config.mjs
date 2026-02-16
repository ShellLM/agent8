import { defineConfig } from 'astro/config';

export default defineConfig({
  site: 'https://shelllm.github.io',
  base: '/agent8',
  output: 'static',
  image: {
    service: {
      entrypoint: 'astro/assets/services/noop'
    }
  }
});
