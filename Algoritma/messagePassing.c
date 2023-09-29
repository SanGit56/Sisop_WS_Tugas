#include <stdio.h>
#include <pthread.h>

#define BUFFER_SIZE 100

char buffer[BUFFER_SIZE];    // shared buffer
int readIndex = 0;           // read index for buffer
int writeIndex = 0;          // write index for buffer

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cond = PTHREAD_COND_INITIALIZER;

void* producer(void* arg) {
  const char* message = "Hello, world!";
  int messageLength = strlen(message);
  int i;

  for (i = 0; i < messageLength; i++) {
    pthread_mutex_lock(&mutex);
    while ((writeIndex + 1) % BUFFER_SIZE == readIndex) {
      pthread_cond_wait(&cond, &mutex);
    }
    buffer[writeIndex] = message[i];
    writeIndex = (writeIndex + 1) % BUFFER_SIZE;
    pthread_cond_signal(&cond);
    pthread_mutex_unlock(&mutex);
  }

  pthread_exit(NULL);
}

void* consumer(void* arg) {
  int i;

  for (i = 0; i < strlen("Hello, world!"); i++) {
    pthread_mutex_lock(&mutex);
    while (readIndex == writeIndex) {
      pthread_cond_wait(&cond, &mutex);
    }
    printf("%c", buffer[readIndex]);
    readIndex = (readIndex + 1) % BUFFER_SIZE;
    pthread_cond_signal(&cond);
    pthread_mutex_unlock(&mutex);
  }

  printf("\n");
  pthread_exit(NULL);
}

int main() {
  pthread_t prodThread, consThread;
  pthread_create(&prodThread, NULL, producer, NULL);
  pthread_create(&consThread, NULL, consumer, NULL);
  pthread_join(prodThread, NULL);
  pthread_join(consThread, NULL);
  return 0;
}
