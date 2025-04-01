# 💻 SayUp-Front

> 🎓 Graduation Project - SayUp

Flutter 기반의 SayUp 프론트엔드 서버입니다. 로그인 화면, 회원가입 화면, 음성 녹음 및 평가 화면, 채팅 화면 등으로 구성되어 있습니다.

<br>

### 🚀 주요 기능

- 음성 인식 및 텍스트 변환
- 실시간 음성 처리
- 안전한 데이터 저장
- 웹소켓 기반 실시간 통신

<br>

### 📁 프로젝트 구조 요약

```
SayUP-Front/
├── android/                 # Android 플랫폼 관련 파일
├── ios/                    # iOS 플랫폼 관련 파일
├── lib/                    # Flutter/Dart 소스 코드
│   ├── main.dart          # 앱의 진입점
│   ├── SignIn.dart        # 로그인 화면
│   ├── SignUp.dart        # 회원가입 화면
│   ├── DashboardPage.dart # 대시보드 화면
│   ├── PronunciationPage.dart # 발음 연습 화면
│   ├── RoleplayPage.dart  # 롤플레이 화면
│   ├── Chatting.dart      # 채팅 화면
│   ├── VoiceRecord.dart   # 음성 녹음 화면
│   ├── MyPage.dart        # 마이페이지 화면
│   ├── service/           # 서비스 관련 코드
│   └── widgets/           # 재사용 가능한 위젯
├── assets/                # 이미지, 폰트 등 리소스 파일
├── test/                  # 테스트 코드
├── pubspec.yaml          # 프로젝트 설정 및 의존성
├── pubspec.lock          # 의존성 버전 잠금 파일
└── README.md             # 프로젝트 문서
```

<br>

### ⚙️ 기술 스택

- Flutter SDK (^3.5.4)
- 주요 패키지:
  - flutter_sound: ^9.0.0 (오디오 녹음 및 재생)
  - speech_to_text: ^7.0.0 (음성 인식)
  - web_socket_channel: ^2.2.0 (실시간 통신)
  - flutter_secure_storage: ^9.2.2 (보안 데이터 저장)
  - stomp_dart_client: ^0.4.4 (STOMP 프로토콜 지원)

<br>

### 🛠️ 개발 환경 세팅

1. 프로젝트 클론
```bash
git clone https://github.com/GraduationProject-SayUp/SayUP-Front.git
```

2. 의존성 설치
```bash
flutter pub get
```

3. 실행
```bash
flutter run
```

<br>

### 📌 기타

🌐 백엔드(SpringBoot)와 통합되어 동작합니다.
