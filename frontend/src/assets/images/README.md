# Diretório de Imagens

## Logo Geek Joke

Adicione o arquivo da logo marca neste diretório:

**Nome do arquivo:** `logo-gj.png`

### Especificações Recomendadas:

- **Formato:** PNG com fundo transparente
- **Tamanho sugerido:** 200px de largura (altura proporcional)
- **Qualidade:** Alta resolução para boa visualização em telas Retina

### Onde a logo é usada:

1. **Tela de Login** - `LoginForm.vue`
   - Exibida no topo do card de login
   - Tamanho máximo: 200px de largura

### Como adicionar:

```bash
# Depois de fazer o git pull, adicione o arquivo aqui:
cp /caminho/para/sua/logo-gj.png frontend/src/assets/images/
```

### Testando a logo:

Após adicionar o arquivo, inicie o servidor de desenvolvimento:

```bash
cd frontend
npm run dev
```

Acesse a tela de login e verifique se a logo está sendo exibida corretamente.
