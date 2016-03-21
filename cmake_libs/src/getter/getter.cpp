#include "getter.h"

Getter::Getter(int i) : i_ {i}
{  }

int  Getter::get() const
{
    return i_;
}

void Getter::set(int i)
{
    i_ = i;
}

int  Getter::get_static()
{
    return static_i_;
}

void Getter::set_static(int stat_i)
{
    static_i_ = stat_i;
}

int Getter::static_i_;
