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
    title: "그런 당신을 위해",
    image: "assets/images/image2.png",
    desc: "지금부터 해야할 복습 루틴\n함께 만들어드릴게요!",
  ),
  OnboardingContents(
    title: "Get notified when work happens",
    image: "assets/images/image3.png",
    desc:
        "Take control of notifications, collaborate live or on your own time.",
  ),
];
