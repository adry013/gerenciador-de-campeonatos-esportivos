# 🏆 Campeonato Esportivo — App Flutter

App Flutter completo para gerenciamento de campeonatos, integrado com a API Flask do backend.

---

## 📁 Estrutura do Projeto

```
lib/
├── main.dart                          # Entry point + navegação
├── constants.dart                     # URL base da API
├── models/
│   ├── time_model.dart
│   ├── jogador_model.dart
│   └── partida_model.dart
├── services/
│   └── api_service.dart               # Todas as chamadas HTTP (CRUD completo)
└── screens/
    ├── dashboard/dashboard_screen.dart  # Totais gerais
    ├── times/times_screen.dart          # CRUD de equipes
    ├── jogadores/jogadores_screen.dart  # CRUD de jogadores
    └── partidas/partidas_screen.dart    # CRUD de partidas
```

---

## ⚙️ Como rodar

### 1. Backend (Flask)
```bash
cd exercicio_backend
pip install -r requirements.txt
python app.py
# Rodará em http://localhost:5000
```

### 2. Banco de dados (MySQL)
Certifique-se de ter o MySQL rodando e o banco `campeonato` criado.
O Flask cria as tabelas automaticamente na primeira execução.

### 3. App Flutter

**No emulador Android** — já configurado (usa `10.0.2.2:5000`).

**Em dispositivo físico** — edite `lib/constants.dart`:
```dart
const String baseUrl = 'http://SEU_IP_LOCAL:5000';
// Ex: 'http://192.168.1.100:5000'
```

```bash
flutter pub get
flutter run
```

---

## 📱 Telas

| Tela | Funcionalidades |
|------|----------------|
| Dashboard | Totais de equipes, jogadores, partidas e gols |
| Equipes | Listar, cadastrar, editar e excluir times |
| Jogadores | Listar, cadastrar (com seleção de time e posição), editar e excluir |
| Partidas | Listar, cadastrar (com seleção de times e data), editar e excluir |

---

## 🔌 Endpoints utilizados (API)

| Recurso | GET | POST | PUT | DELETE |
|---------|-----|------|-----|--------|
| `/times` | ✅ | ✅ | ✅ `/times/:id` | ✅ `/times/:id` |
| `/jogadores` | ✅ | ✅ | ✅ `/jogadores/:id` | ✅ `/jogadores/:id` |
| `/partidas` | ✅ | ✅ | ✅ `/partidas/:id` | ✅ `/partidas/:id` |

---

## ⚠️ Observação sobre o Backend

O backend enviado usa rotas REST padrão (ex: `GET /times`, `DELETE /times/1`),
**diferente** do documento que mostra rotas como `/listaequipes`, `/removeequipe` etc.
O app Flutter foi desenvolvido para funcionar com o código real do backend entregue.
