#include <stdio.h>

int reverseNumber(int n) {
    int reversed = 0;
    while (n > 0) {
        reversed = reversed * 10 + (n % 10);
        n /= 10;
    }
    return reversed;
}

int main() {
    int n;
    printf("Enter a number: ");
    scanf("%d", &n);

    int result = reverseNumber(n);
    printf("Reversed number: %d\n", result);

    return 0;
}
