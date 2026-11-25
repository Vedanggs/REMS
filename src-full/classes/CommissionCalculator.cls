public class CommissionCalculator {

    public static Decimal calculateCommission(
        Decimal dealValue,
        String tier
    ) {
        if (dealValue == null || dealValue <= 0) {
            return 0;
        }

        Decimal rate;

        if (tier == 'Junior') {
            rate = 0.01;
        } 
        else if (tier == 'Senior') {
            rate = 0.015;
        } 
        else if (tier == 'Top') {
            rate = 0.02;
        } 
        else {
            throw new IllegalArgumentException('Invalid agent tier');
        }

        return (dealValue * rate).setScale(2);
    }
}