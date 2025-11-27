require x >= 0
ensure y == x * 2
{
    y = 0;
    inv y == x * 2 - i * 2 && i >= 0
    while (i < x) {
        y = y + 2;
        i = i + 1
    }
}
