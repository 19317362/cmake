#ifndef GETTER1_H
#define GETTER1_H

#include "getter.h"

class Getter1 {
public:
    Getter1(int i);
    int  get() const;
    void set(int i);

    static int  get_static();
    static void set_static(int i);

private:
    Getter getter_;
};

#endif
