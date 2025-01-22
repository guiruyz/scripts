import pandas as pd
import matplotlib.pyplot as plt

csv_file = "power_log_2025-01-22_18-54-48.csv"

data = pd.read_csv(csv_file)

data['timestamp'] = pd.to_datetime(data['timestamp'])

plt.figure(figsize=(10, 6))
plt.plot(data['timestamp'], data['realtime_power'], label='Consumo Atual (Watts)', marker='o')
plt.plot(data['timestamp'], data['cpu_power'], label='Consumo Atual de CPU (Watts)', marker='o')

plt.title('Consumo de Energia do Servidor')
plt.xlabel('Timestamp')
plt.ylabel('Consumo (Watts)')
plt.legend()
plt.grid(True)
plt.xticks(rotation=45)

plt.savefig("consumo_energia.png")

plt.show()
