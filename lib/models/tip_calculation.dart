/// Pure calculation logic for the tip calculator (easy to test).
class TipCalculation {
  const TipCalculation({
    required this.billAmount,
    required this.tipPercent,
    required this.splitCount,
  });

  final double billAmount;
  final double tipPercent;
  final int splitCount;

  double get tipAmount => billAmount * tipPercent / 100;

  double get totalAmount => billAmount + tipAmount;

  double get perPerson => totalAmount / splitCount;
}
