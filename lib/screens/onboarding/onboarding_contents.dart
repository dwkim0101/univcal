class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "공부하다보면",
    image: "assets/images/image1.png",
    desc: "수업듣고 또 복습하고 정신은 하나도 없는데\n매번 새로 손수 일정짜기 귀찮으셨죠?",
  ),
  OnboardingContents(
    title: "복습을 도와드릴게요!",
    image: "assets/images/image2.png",
    desc: "",
  ),
  OnboardingContents(
    title: "그러면 이제\n시작해볼까요?",
    image: "assets/images/image3.png",
    desc: "아래 버튼을 눌러 시작해봐요 !",
  ),
];
