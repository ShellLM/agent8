// @ts-check

import mdx from '@astrojs/mdx';
import { defineConfig } from 'astro/config';

// https://astro.build/config
export default defineConfig({
	site: 'https://shelllm.github.io',
	base: '/agent8/',
	integrations: [mdx()],
	markdown: {
		shikiConfig: {
			theme: 'dracula',
		},
	},
	build: {
		inlineStylesheets: 'auto', // Win from Trial 1
	},
	vite: {
		build: {
			minify: 'esbuild', // Win from Trial 1
			sourcemap: false,   // Win from Trial 2
			cssCodeSplit: true,
		},
	},
});
