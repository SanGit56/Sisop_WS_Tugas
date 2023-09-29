#include <stdio.h>
#include <stdlib.h>
#include <semaphore.h>
#include <pthread.h>

int global_var = 0;
sem_t mutex;

void *function_increment(void *arg) {
    int *thread_id = (int *) arg;
    printf("Running thread no : %d\n", *thread_id);

   // thread operation to increment shared variable
    for (int i = 0; i < 200; i++) {
//        printf("--getting a semaphore\n");
        sem_wait(&mutex); //getting semaphore
//        printf("performing operation number : %d by thread %d \n ", i+1, *thread_id);
        global_var++;
 //       printf("++releasing the locked semaphore\n");
        sem_post(&mutex); // Release the semaphore
    }

    printf("Stopping thread no : %d\n", *thread_id);
    printf("=> Current value of global variable is %d \n",global_var);
    printf("--------------------------------------------------\n");
    pthread_exit(NULL);
}

int main() {
    int threads_no=0;
    printf("Please enter the number of threads (>0): ");

    scanf("%d", &threads_no);
    printf("=================================================\n");
    pthread_t threads[threads_no];

    sem_init(&mutex, 0, 1);  // initialize semaphore as 1

    // Create and start the threads based on the number of threads created 
    for (int i = 0; i < threads_no; i++) {
        int *thread_id = malloc(sizeof(int));
        *thread_id = i;
        pthread_create(&threads[i], NULL, function_increment, (void *) thread_id);
    }

    // Join the results of the thread operations
    for (int i = 0; i < threads_no; i++) {
        pthread_join(threads[i], NULL);
    }

    printf("=>The final value of the global variable is  %d.\n", global_var);
    sem_destroy(&mutex);  // destroy the semaphore
    return 0;
}