import { defineConfig } from 'vitepress'
import { apiSidebar } from './generated/api-sidebar'
import { guideSidebar } from './generated/guide-sidebar'
import { dartpadPlugin } from './theme/plugins/dartpad'
import { apiLinkerPlugin } from './theme/plugins/api-linker'
// llmstxt disabled for large SDK docs builds (OOM with 2760+ pages)
// import llmstxt, { copyOrDownloadAsMarkdownButtons } from 'vitepress-plugin-llms'

export default defineConfig({
  title: 'Dart SDK API',
  description: 'API documentation for Dart SDK',
  base: '/dart-sdk-api/',
  // Cross-references to SDK types (dart:core, dart:collection) produce
  // dead links since we only generate docs for this package.
  ignoreDeadLinks: true,
  // Disabled for build perf: 1800+ individual git log calls cause OOM.
  // Re-enable when VitePress 2 ships single-git-call optimization.
  lastUpdated: false,
  // Limit concurrent page rendering (default: 64). Lower = less peak memory.
  buildConcurrency: 2,
  // Extract page metadata into a shared chunk instead of inlining in each HTML.
  metaChunk: true,
  vite: {
    build: {
      sourcemap: false,
      rollupOptions: {
        cache: false,
      },
    },
  },
  markdown: {
    config: (md) => {
      md.use(dartpadPlugin)
      md.use(apiLinkerPlugin)
    },
  },
  themeConfig: {
    // "On this page" outline: show h2–h4 with nested tree structure.
    outline: { level: [2, 4] },
    // Full-text search powered by MiniSearch (built into VitePress).
    search: {
      provider: 'local',
    },
    // Navigation bar links.
    nav: [
      { text: 'Guide', link: '/guide/' },
      { text: 'API Reference', link: '/api/' },
    ],
    sidebar: {
      ...apiSidebar,
      ...guideSidebar,
    },
    socialLinks: [{ icon: 'github', link: 'https://github.com/dart-lang/sdk' }],
  },
})
