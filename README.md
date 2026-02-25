# BlockRemote - IOS design patterns Cybersecurity Real Defense System 

## Overview
BlockRemote é um motor de defesa de soberania digital desenvolvido em Flutter/Dart. O sistema foi projetado para neutralizar ameaças de acesso remoto (RATs) e ataques de "mão fantasma" através de telemetria de sensores de hardware em alta frequência e uma arquitetura de blindagem ativa.

## Architecture
- **Framework**: Flutter 3.41.2 (Dart 3.11.0) otimizado para iOS nativo.
- **State Management**: Implementação do padrão Provider (ChangeNotifier) para orquestração de estados globais reativos.
- **UI Rendering**: Processamento gráfico via CustomPaint para radar e telemetria; BackdropFilter para camadas de glassmorphism.
- **Typography**: Sistema dual-font utilizando Inter para elementos de interface e JetBrains Mono para fluxos de dados técnicos.
- **Platform**: Engine híbrida construída para Web com foco em performance e feedback tátil de nível iOS.

## Project Structure
```plaintext
lib/
  main.dart                 - Ponto de entrada, roteamento de splash e transições de página
  theme/
    app_theme.dart          - Paleta de cores Enterprise e sistema AppFonts
  components/
    neon_container.dart     - Container com gradiente e borda neon luminescente
    cyber_button.dart       - Botão animado com integração de feedback háptico
    security_card.dart      - Card de item de lista com suporte a gestos e gradientes
    neon_switch.dart        - Toggle switch customizado com brilho neon
    wave_painter.dart       - CustomPainter para renderização de gráficos em tempo real
    glass_container.dart    - Abstração de BackdropFilter para interface glassmorphism
    breathing_glow.dart     - Wrapper de animação pulsante via AnimationController
  screens/
    splash_screen.dart           - Sequência de inicialização e boot do sistema
    dashboard_screen.dart        - Painel central com radar animado e simulador de ameaças
    sensor_monitor_screen.dart   - Monitoramento de ondas de sensores em tempo real
    app_shield_screen.dart       - Gestão de camadas de proteção e modais de detalhes
    audit_logs_screen.dart       - Visualizador de logs em estilo terminal
    settings_screen.dart         - Configuração de sensibilidade e parâmetros de defesa
    subscription_overlay.dart    - Paywall em glassmorphism (Modelo R$ 9,90/mês)
  services/
    security_state.dart     - Estado global (contadores, sensores, logs e subscrição)
server.dart                 - Servidor HTTP Dart para orquestração de build web (Porta 5000)
```

## Premium Features (Enterprise Refinements)
- **Glassmorphism**: Aplicação de BackdropBlur em AppBar e BottomNav com sobreposição de gradientes.
- **Dynamic Glow**: Animação de pulsação (breathing) em todos os elementos de status seguro.
- **Status Orb**: Orbe neon pulsante com arcos rotativos, sweep de scan e marcações de precisão.
- **Subscription Paywall**: Overlay "Digital Vault" minimalista com fundo True Black, textura de circuitos via CustomPaint (~8% opacidade) e card central em glassmorphism.
- **Live Counters**: Monitoramento contínuo de Requisições Analisadas, Integridade de Memória e Pacotes Escaneados.
- **Boot Sequence**: Splash de inicialização técnica com 21 linhas de comando e barra de progresso.
- **Haptic Feedback Engine**: Respostas táteis estratificadas (Light para navegação, Heavy para ameaças, Selection para toggles).
- **Visual Confort**: Fundo #000000 absoluto otimizado para telas OLED e redução de consumo energético.

## Color Palette
- Background: #000000 (True Black OLED)
- Surface: #0D1117 (Carbon Grey)
- Primary Neon: #00FF41 (Matrix Green)
- Secondary Neon: #ADFF2F (Cyber Lime)
- Text: #F1F2F1 (Off-White)
- Danger: #FF0040

## Running
O aplicativo é servido via servidor HTTP Dart na porta 5000. O SDK do Flutter está localizado em `/home/runner/flutter/`.

Para reconstruir após alterações:
```bash
export PATH="/home/runner/flutter/bin:$PATH"
flutter build web --release
```
