// 사이트 전역 상수. 여기만 고치면 헤더/푸터/메타에 반영된다.
export const SITE = {
  title: '최한글',
  // 헤더 로고 옆/타이틀에 쓰이는 짧은 태그라인
  tagline: '백엔드 · AI 시스템 엔지니어링',
  description:
    '백엔드와 AI 시스템을 만들며 얻은 결정·교훈·트러블슈팅을 기록하는 기술 블로그.',
  author: '최한글',
  // 절대 URL 생성용 (astro.config 의 site 와 일치)
  url: 'https://chg9252.github.io',
  lang: 'ko',
};

export const NAV = [
  { label: '글', href: '/blog' },
  { label: '소개', href: '/about' },
];

export const SOCIAL = [
  { label: 'GitHub', href: 'https://github.com/chg9252' },
  // 필요 시 추가: { label: 'LinkedIn', href: '...' },
];
