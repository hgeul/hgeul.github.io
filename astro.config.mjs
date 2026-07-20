// @ts-check
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

// 개인 유저 사이트(chg9252.github.io)이므로 base 는 '/'.
// 커스텀 도메인을 붙이면 site 값만 그 도메인으로 바꾸면 된다.
export default defineConfig({
  site: 'https://hgeul.github.io',
  integrations: [sitemap()],
  markdown: {
    shikiConfig: {
      // 코드블록 테마: 라이트/다크 각각. global.css 의 팔레트와 어울리는 조합.
      themes: {
        light: 'github-light',
        dark: 'github-dark-dimmed',
      },
      wrap: true,
    },
  },
});
