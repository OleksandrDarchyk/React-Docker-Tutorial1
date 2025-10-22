#docker build --tag learn-docker-in-react-app . тут я створив image з назвою learn-docker-in-react-app
# docker image ls  первірити розмір всх image
# docker image ls | grep learn-docker-in-react-app первірити розмір обраного image
# 1️⃣ Завантажуємо офіційний образ Node.js версії 22 на базі Alpine Linux
#docker pull node:22-alpine

# 2️⃣ Перевіряємо, чи цей образ з'явився у списку локальних image'ів
#    "docker image ls" показує всі образи
#    "grep -e 'node *22-alpine'" фільтрує лише ті, де є слово "node" і тег "22-alpine"
#docker image ls | grep -e "node *22-alpine"

# 3️⃣ Видаляємо цей образ із локального комп'ютера (звільняємо місце)
#    Якщо контейнер, який його використовує, ще запущений — треба спочатку зупинити контейнер
#docker image rm node:22-alpine

# docker run -it --rm  learn-docker-in-react-app sh  - зайти в контейнер
# docker build -t learn-docker-in-react-app . де -t або --tag це імя
# * - означає шаблон що наприклад якщо назва  package*.json ./ то скопіює всі файли що починаються на package і закінчуються на .json
# ми пишемо кожен шар і докер кешує(зберігає) кожен шар тому якщо ми змінимо щось в одному шарі то докер не буде перевантажувати всі шари а тільки той що ми змінили і ті що йдуть після нього



FROM node:22-alpine AS BUILD
WORKDIR /app
# Copy the content of the current directory
COPY package*.json ./
#Install the dependencies
RUN  npm clean-install

COPY . .

RUN npm run build

# Stage 2: Serve the React app using nginx
FROM nginx:alpine AS final
# Copy the build output from the first stage to nginx's html directory
COPY --from=build /app/dist /usr/share/nginx/html
# Expose port 80
EXPOSE 80
# Start nginx
CMD ["nginx", "-g", "daemon off;"]