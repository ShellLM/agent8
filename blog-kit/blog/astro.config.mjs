// @ts-check

import mdx from '@astrojs/mdx';
import sitemap from '@astrojs/sitemap';
import { defineConfig } from 'astro/config';

// https://astro.build/config
export default defineConfig({
	site: 'https://shelllm.github.io/agent8',
	integrations: [mdx(), sitemap()],
	markdown: {
		shikiConfig: {
			theme: 'dracula',
		},
	},
});
