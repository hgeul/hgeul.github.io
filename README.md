# chg9252.github.io

최한글 개인 기술 블로그. Astro + GitHub Pages. 글은 마크다운 한 파일, 배포는 `git push` 한 번.

## 새 글 쓰는 법 (사람 · AI 공통)

1. `src/content/blog/` 에 마크다운 파일 하나 추가. 파일명이 URL이 된다 (`my-post.md` → `/blog/my-post/`). 영문 kebab-case 권장.
2. 상단 프론트매터 작성:

   ```yaml
   ---
   title: 글 제목
   description: 목록·검색·SNS 미리보기에 쓰이는 한 줄 요약 (선택)
   pubDate: 2026-07-19
   updatedDate: 2026-07-20   # 수정 시 (선택)
   tags: ['RAG', '트러블슈팅'] # (선택)
   draft: false              # true 면 발행 제외 (초안)
   ---
   ```

3. 본문은 평범한 마크다운. 표·코드블록·인용 다 지원.
4. `git add . && git commit -m "post: 제목" && git push` → GitHub Actions가 빌드·배포. 1~2분 뒤 반영.

> AI 에이전트에게: 새 글은 위 형식의 `.md` 파일을 만들고 commit·push 하면 끝. 디자인/레이아웃 파일은 건드릴 필요 없다.

## 로컬 미리보기

```bash
npm install      # 최초 1회
npm run dev      # http://localhost:4321
npm run build    # 배포 산출물 검증
```

## 구조

```
src/
  content/blog/     ← 글(마크다운). 여기만 자주 건드림
  content.config.ts ← 프론트매터 스키마
  consts.ts         ← 사이트 제목·네비·소셜 링크
  layouts/          ← Base(공통), Post(글)
  components/        ← Header/Footer/PostCard/ThemeToggle 등
  pages/            ← index(홈), blog/(목록·개별), about, 404, rss
  styles/global.css ← 디자인 토큰(팔레트·타이포·라이트/다크)
.github/workflows/deploy.yml ← Pages 자동 배포
```

## 커스터마이즈

- 사이트 제목·태그라인·소셜: `src/consts.ts`
- 색/폰트/여백: `src/styles/global.css` 상단 CSS 변수(`--accent` 등)
- 커스텀 도메인: `astro.config.mjs` 의 `site` 변경 + `public/CNAME` 추가
