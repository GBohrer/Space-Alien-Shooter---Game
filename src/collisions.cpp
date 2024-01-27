
#include "collisions.h"

bool ColisaoPontoPlano(float yp, float yc){
    float altura = 5;
    bool colisao=0;

    if(yp == altura+yc){
        colisao=1;
    }

    return colisao;
}
