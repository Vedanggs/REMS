@isTest
private class CommissionCalculatorTest {

    @isTest
    static void testJuniorCommission() {
        Decimal result = CommissionCalculator.calculateCommission(100000, 'Junior');
        System.assertEquals(1000, result);
    }

    @isTest
    static void testSeniorCommission() {
        Decimal result = CommissionCalculator.calculateCommission(100000, 'Senior');
        System.assertEquals(1500, result);
    }

    @isTest
    static void testTopCommission() {
        Decimal result = CommissionCalculator.calculateCommission(100000, 'Top');
        System.assertEquals(2000, result);
    }

    @isTest
    static void testZeroDealValue() {
        Decimal result = CommissionCalculator.calculateCommission(0, 'Junior');
        System.assertEquals(0, result);
    }
}