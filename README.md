# Trabalho Final - Fundamentos de Computação Gráfica (INF01047)

![menu](https://github.com/Huthee/Space-Alien-Shooter---Game/assets/89394453/4ad2a07f-c2dd-4a56-8f64-c66c2a4b60df)

## Sobre o Jogo

Segundo o conceito de jogos _roguelike_ da [wikipédia](https://pt.wikipedia.org/wiki/Roguelike):

  > O roguelike (ou rogue-like) é um subgênero de jogo RPG, caracterizado pela **geração de nível aleatóriamente** ou procedural durante a partida, mapa geralmente baseado em ladrilho e *morte permanente*[...]

Space Alien Shooter tem a premisa de ser um simples jogo no estilo FPS com o intuito de uma jogabilidade _Roguelike_ e sob uma premissa de Sci-Fi. O jogador, um viajante espacial perdido em uma planeta inóspito, precisa derrotar todos os alienígenas locais para sobreviver à sua viagem interestelar. Contudo, os alienígenas se tornam cada vez mais agressivos perante o viajante...

O objetivo principal do jogo é manter o viajante o maior tempo possível vivo. Com isso, ele conta com uma arma laser, capaz de atirar múltiplos raios e executar os alienígenas em um instante. Além disso, o viajante conta com um exoesqueleto, o permitindo saltar em zero-gravidade, algo que o auxilía na batalha contra os alienígenas.

## Processo de Desenvolvimento

A aplicação deste projeto foi desenvolvido inteiramente através da IDE Code::Blocks, utilizando como base os laboratórios práticos da disciplina. Devido à falta de planejamento e tempo, o jogo foi feito de modo estruturado e sequencial. Isso colide com o intuito inicial, cujo era utilizar POO e adicionar muitas outras _features_ (como _power ups_, atributos de vida, e outros alienígenas mais "perigosos". Por isso, grande parte do código será encontrado na `main.cpp`, abrindo exceção apenas para as funções de colisões, encontradas na `collisions.cpp`.

Referente aos requisitos exigidos pela disciplina, o Space Alien Shooter possui:

 ### 1. **Interação em tempo real, possibilitando interação com o usuário através do mouse e do teclado**

> [!NOTE]
> - Movimentação do jogador através das teclas [W A S D] do teclado + tecla [SPACE] para realizar o pulo do jogador;
> - Movimentação da mira da arma laser através da movimentação do mouse com o [RIGHT-BUTTON] precionado;
> - Disparo dos lasers da armr através da movimentação do mouse com o [LEFT-BUTTON] precionado;

<p align="center">
  <img src="/content/gif_movement.gif">
</p>

### 2. **Utilização das matrizes (vistas na disciplina) para transformações geométricas**

> [!NOTE]
> - _Matrix_Translate()_ foi extremamente útil para definir a posição dos alienígenas pelo cenário;
> - _Matrix_Scale()_ e _Matrix_Rotate()_ são utilizadas nos modelos de renderização de todos os objetos para corrigir o tamanho e/ou orientação dos objetos no cenário;
> - _Matrix_Camera_View()_ é utilizada na definição da câmera virtual;

### 3. **Malhas poligonais complexas e transformações geométricas de objetos virtuais**

> [!NOTE]
> - A aplicação inclui modelos geométricos de alta complexidade através de arquivos .obj (como o modelo dos alienígenas);
> - Todas as instâncias dos alienígenas são aplicadas utilizando o mesmo conjunto de vértices e sofrem translações em direção ao jogador constantemente;

<p align="center">
  <img src="/content/alien_model_info.png">
</p>

### 4. **Câmera Livre e _Look-At_**

> [!NOTE]
> - A câmera virtual durante a tela inicial de menu é Look-At;
> - A câmera virtual durante o jogo é uma câmera livre, onde o usuário pode olhar para todas as direções e movimentá-la baseado na movimentação do viajante;

### 5. **Modelos de iluminação de objetos geométricos**

Foram usados ao total 2 modelos de iluminação. Estes foram:

> [!NOTE]
> - Para os aliens está sendo utilizado o modelo de Phong, que calcula a iluminação em cada ponto do objeto;
> - Para a arma está sendo utilizado o modelo de Gouraud que calcula a iluminação em cada vertice dos triângulos do objeto e utiliza uma interpolação para as demais áreas do triângulo;

<p align="center">
  <img src="/content/ilumination_exemple.png">
</p>

### 6. **Mapeamento de Texturas**

Para o mapeamento foram feitos duas formas diferentes. Estas foram:

> [!NOTE]
> - Para a esfera (skybox) é realizado um mapeamento de textura esférica usando coordenadas polares. Ele calcula as coordenadas esféricas a partir do vetor normalizado que aponta do centro da esfera para o ponto na esfera.
> - Os demais objetos utilizam coordenadas de textura que são obtidas diretamente do arquivo de textura de cada objeto.

### 7. **Animação de Movimento baseada no tempo e Curvas de Bezier**

> [!NOTE]
>  - A movimentação dos alienígenas que perseguem o jogador são computadas baseadas no tempo de um `delta_t` (utilizando `GLFWGetTime()`);
>  - O alienígena "perdido" da tela inicial de menu realiza sua movimentação definida através de uma **curva de Bézier cúbica**;

<p align="center">
  <img src="/content/gif_bezier.gif">
</p>

### 8. **Testes de intersecção entre objetos virtuais**

Os testes de intersecção foram implementados a partir de _hitboxes_. Toda instância de objetos (alienígenas, lasers e o jogador) possui uma hitbox instânciada em sua posição atual. Três tipos de testes de intersecção foram implementados. São eles:

> [!NOTE]
> - Teste de colisão **Ponto-Plano**: Verifica se o ponto da câmera livre (jogador) está acima do plano do chão. Este teste, se verdadeiro, não permite o jogador atravesar a superfície do planeta quando realiza a descida dos pulos; 
> - Teste de colisão **Esfera-Esfera**: Verifica se a hitbox do laser colidiu com a hitbox do alienígena; Este teste, se verdadeiro, gera um novo alienígena no cenário e permite aumentar a dificuldade do jogo;
> - Teste de colisão **Cubo-Esfera**: Verifica se a hitbox cúbida do jogador colidiu com a hitbox esférica do alienígena; Este teste, se verdadeiro, encerra o jogo atual, realizando a reinicialização do jogo para a tela inicial de menu;

<p align="center">
  <img src="/content/gif_alien_bullet.gif">
  <img src="/content/gif_death.gif">
</p>

### 9. **Assistência de outras ferramentas**

> [!WARNING]
> - **ChatGPT**: Inicialmente foi utilizado para fornecer _insights_ sobre métodos de estruturas de dados C++ (como `std::tuple` e `std::vector`) e para fornecer um código que realizasse a movimentação dos alienígenas. Contudo, a ferramenta não se mostrou útil, uma vez que seus resultados não auxiliaram em nossa implementação, não utilizando bibliotecas como a OpenGL;
> - **Blender 3D**: Utilizado para criar os modelos do título da tela inicial e a mira (HUD) da arma laser;
> - **Utilização de no máximo 15% de código pronto**: Função do cálculo de uma curva bezier. Este código foi um pouco modificado para possuir parâmetros que fizessem sentido em nossa aplicação. [FONTE](https://medium.com/geekculture/2d-and-3d-b%C3%A9zier-curves-in-c-499093ef45a9)

## Compilação e execução da aplicação

1. Baixe o ZIP deste projeto;
2. Baixe e instale a IDE Code::Blocks (de preferência) [aqui](https://www.codeblocks.org/downloads/binaries/)
3. Realize as configurações necessárias de compilador MingW
4. Abra o diretório e execute o arquivo `TrabalhoFinal.cbp`
5. Clique em **Build and Run**

## Execução sem compilação:

1. Baixe o ZIP deste projeto;
2. Abrir o diretório do projeto
3. Abrir o diretório bin e consequentemente abrir a pasta Debug
4. executar o arquivo main.exe

## Contribuições

O projeto teve contribuições significativas de ambos integrantes do grupo, onde foi adotado o _pair programming_. Ambos os integrantes decidiam, em conjunto, a direção da aplicação, o que implementar e na correção de bugs.

### Gabriel Alves Bohrer
- Alienígenas (Aliens) e lasers (bullets). Transformações geométricas, geração e lógicas;
- Curvas de Bezier;
- Teste de Colisão Esfera-Esfera
- Modelação do título (title) e mira (hud);
- Tela inicial de menu;
- Aumento da dificuldade ao longo do jogo;
- Documentação, ajustes (câmeras), melhorias e "game design";
  
### Jefferson Ruan Barcelos Godinho
- Modelos de iluminação;
- Arma (Gun). Transformações geométricas;
- Teste de Colisão Ponto-Plano;
- Teste de Colisão Cubo-Esfera;
- Carregamento de objetos e texturas;
- Pulo do jogador;
- Implementação da _SkyBox_;
- Documentação, ajustes (câmeras), melhorias e "game design";

## After-Release

A visão tida pelos contribuintes do projeto não foi totalmente atingida. Além dos pontos ditos no início da seção de Processo de Desenvolvimento, existem algumas mudanças e implementações que serão feitas, independente da entrega final deste trabalho. Elas seriam:

- **Mudança da geração dos alienígenas:** Coordenadas polares -> Coordenadas esféricas;
- **Correção do armazenamento das posições dos alienígenas**: Trocar a estrutura de dados de `std::vector` para uma Classe Alien;
- **Correção do disparo dos lasers**: O laser não saí corretamente da ponta da arma laser;
- **Implementação da orientação correta de objetos**: Atualizar a orientação dos alienígenas e dos lasers conforme a direção do movimento (objetos "olharem" para onde estão indo);
- **Expansão do cenário**: Carregar dinamicamente o plano do chão com a textura do planeta;
- **Modularização do código**: Subdividir a `main.cpp` em outros arquivos, tal como criar classes e funções adequadas para o jogo;
