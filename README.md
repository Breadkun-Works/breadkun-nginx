# breadkun-nginx

## 개요

`breadkun-nginx`는 **Nginx 기반 리버스 프록시 컨테이너**로, SSL 인증서 관리 및 CORS 지원을 통해 안전한 트래픽 라우팅을 제공합니다. Docker Compose를 활용하여 동적으로 환경 변수를 주입받으며, GitHub Actions를 통한 CI/CD 배포 프로세스를 갖추고 있습니다.

---

## 주요 기능

### 1. SSL 인증서 관리

- 호스트 머신(VM)에서 관리되는 **Let's Encrypt SSL 인증서를 마운트**하여 HTTPS 요청을 처리합니다.
- HTTP 요청을 자동으로 HTTPS로 리디렉션하여 보안성을 강화합니다.

### 2. CORS 지원

- 환경 변수를 통해 허용할 Origin을 동적으로 설정할 수 있습니다.
- 프리플라이트 요청(OPTIONS) 및 일반 요청(GET, POST 등)에 대한 CORS 정책을 적용합니다.

---

## 템플릿 기반 설정

**이 프로젝트는 `default.conf.template` 파일을 활용하여 컨테이너 실행 시 `default.conf`를 동적으로 생성**합니다.

- 환경 변수는 **Docker Compose에서 자동으로 주입**됩니다.
- `ENTRYPOINT` 스크립트가 환경 변수를 읽어 Nginx 설정을 동적으로 반영합니다.

---

## SSL 인증서 설정

SSL 인증서는 호스트 머신(VM)에서 **Let's Encrypt**를 사용하여 관리되며, `certbot`과 `systemd timer`를 통해 자동으로 갱신됩니다.

Nginx 컨테이너는 호스트 머신의 `/etc/letsencrypt` 디렉토리를 읽기 전용으로 마운트하여 인증서를 사용합니다. Docker Compose 실행 시 자동으로 마운트됩니다.

```yaml
volumes:
  - /etc/letsencrypt:/etc/letsencrypt:ro
```

---

## 배포 프로세스 (CI/CD)

이 프로젝트는 **GitHub Actions**를 사용하여 자동화된 배포 프로세스를 수행합니다.

### 1. 빌드 단계

- `master` 브랜치에 코드가 푸시되면 **GitHub Actions**가 실행됩니다.
- `docker build`를 사용하여 Nginx 컨테이너 이미지를 빌드합니다.
- CI/CD 환경 변수는 **GitHub Actions에서 자동으로 주입**됩니다.

### 2. 배포 단계

- 기존 컨테이너를 중지하고 삭제한 후 새 이미지를 배포합니다.
- 빌드된 이미지를 원격 서버에 배포합니다.
- `docker compose up -d`를 실행하여 컨테이너를 마운트합니다.
- **`default.conf.template`의 환경 변수는 컨테이너 마운트 시 `docker-compose`에서 주입됩니다.**

