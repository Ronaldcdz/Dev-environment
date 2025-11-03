# Herramientas instaladas aparte del setup

Esto es una lista de las herramientas que no necesariamente tienen que estar en el setup de todas mis herramientas de trabajo, ya sea por que las estoy probando o porque son situacionales.

**Nota:** todas las herramientas son instaladas con scoop.

- **Kanata**

```powershell
scoop bucket add extras
scoop install extras/kanata
```

## INSTALAR MÁS TARDE

Hacer script de git para que haga lo siguiente:
```bash
git add .
git commit "Current Work"
git push origin
```

Despues en otra maquina que haga lo siguiente:
```bash
git pull
git reset .
```

Para obtener el ultimo commit y que lo deshaga del que esta en github, sería como sicronizar y quitando el commit para no tenerlo en el historial.

Esto con el propósito de trabajar desde otra app en caso de que vuelva a WSL.
