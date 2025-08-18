#include <stdio.h>

int mod_inverse(int a, int b)
{
    int r0 = a, r1 = b;   
    int s0 = 1, s1 = 0;        // Bézout Arguments

    while (r1 != 0) {
        int q  = r0 / r1;      // Quotient
        int t  = r0 - q * r1;  // Remainder
        r0 = r1;               // (r0,r1) ← (r1,t) 
        r1 = t;

        t  = s0 - q * s1;      // Update Bézout Arguments
        s0 = s1;
        s1 = t;
    }

    if (r0 != 1)               // gcd != 1, no mod inverse
        return -1;

    if (s0 < 0)                // translate to smallest postive integer
        s0 += b;
    return s0;
}

int main() {
    int a, b;
    printf("Enter the number: ");
    scanf("%d", &a);
    printf("Enter the modulo: ");
    scanf("%d", &b);

    int inv = mod_inverse(a, b);
    if (inv == -1) {
        printf("Inverse not exist.\n");
    } else {
        printf("Result: %d\n", inv);
    }

    return 0;
}
