#include "getter1.h"

Getter1::Getter1(int i) : getter_{i}
{  }

int  Getter1::get() const
{
    return getter_.get();
}

void Getter1::set(int i)
{
    getter_.set(i);
}

int  Getter1::get_static()
{
    return Getter::get_static();
}

void Getter1::set_static(int stat_i)
{
    Getter::set_static(stat_i);
}
