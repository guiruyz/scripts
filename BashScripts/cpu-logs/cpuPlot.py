import pandas as pd
import matplotlib.pyplot as plt

# Função para carregar os dados e plotar os gráficos
def plot_cpu_usage(csv_file):
    try:

        df = pd.read_csv(csv_file)

        df["timestamp"] = pd.to_datetime(df["timestamp"])

        fig, ax1 = plt.subplots(figsize=(10, 5))


        ax1.plot(df["timestamp"], df["cpu_usage"], label="Uso da CPU (%)", color="b", linestyle="-")

        ax1.plot(df["timestamp"], df["process_cpu"], label="Uso da CPU (PID) (%)", color="r", linestyle="--")

        ax1.set_xlabel("Tempo")
        ax1.set_ylabel("Uso da CPU (%)")
        ax1.set_title("Uso da CPU ao Longo do Tempo")
        ax1.set_ylim(0, 100) 
        ax1.legend()
        plt.xticks(rotation=45) 
        plt.grid(True)

        # Exibir o gráfico
        plt.show()

    except FileNotFoundError:
        print("Erro: Arquivo não encontrado. Certifique-se de que o nome do arquivo está correto.")
    except Exception as e:
        print(f"Ocorreu um erro: {e}")

csv_file = input("Digite o nome do arquivo CSV: ")

plot_cpu_usage(csv_file)
