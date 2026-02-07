int main() {
    volatile int x = 5;
    volatile int y = 10;
    volatile int z = x + y;

    while (1) {
        // infinite loop
    }

    return 0;
}
