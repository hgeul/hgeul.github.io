// 사이트 전역 상수. 여기만 고치면 헤더/푸터/메타에 반영된다.
export const SITE = {
  title: 'hgeul',
  // 헤더 로고 옆/타이틀에 쓰이는 짧은 태그라인
  tagline: 'BUILD & COLLECT',
  description:
    '좋은 글, 나의 속도로 넓혀가는 작은 코스모스.',
  author: '최한글',
  // 절대 URL 생성용 (astro.config 의 site 와 일치)
  url: 'https://hgeul.github.io',
  lang: 'ko',
};

export const NAV = [
  { label: '글', href: '/blog' },
  { label: '소개', href: '/about' },
];

export const SOCIAL = [
  { label: 'GitHub', href: 'https://github.com/hgeul' },
  // 필요 시 추가: { label: 'LinkedIn', href: '...' },
];
