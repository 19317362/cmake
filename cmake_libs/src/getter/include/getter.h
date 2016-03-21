#ifndef GETTER_H
#define GETTER_H

class Getter {
public:
    Getter(int i);
    int  get() const;
    void set(int i);

    static int  get_static();
    static void set_static(int i);

private:
    int i_;
    static int static_i_;
};

#endif
