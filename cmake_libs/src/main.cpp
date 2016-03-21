#include <iostream>
#include "getter.h"
#include "getter1.h"

int main()
{
    Getter g0(0);
    Getter1 g1(1);
    std::cout << "g0.get()        == " << g0.get()        << std::endl;
    std::cout << "g0.get_static() == " << g0.get_static() << std::endl;
    std::cout << "g1.get()        == " << g1.get()        << std::endl;
    std::cout << "g1.get_static() == " << g1.get_static() << std::endl;

    g0.set_static(11);
    std::cout << "... after g0.set_static(11); ..." << std::endl;
    std::cout << "g0.get_static() == " << g0.get_static() << std::endl;
    std::cout << "g1.get_static() == " << g1.get_static() << std::endl;

    g1.set_static(12);
    std::cout << "... after g1.set_static(12); ..." << std::endl;
    std::cout << "g0.get_static() == " << g0.get_static() << std::endl;
    std::cout << "g1.get_static() == " << g1.get_static() << std::endl;
    return 0;
}
