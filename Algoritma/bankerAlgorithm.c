#include <stdio.h>

int main()
{
    int n, m, i, j, k;
    n = 5; // Number of processes
    m = 3; // Number of resources

    // Initialize claim matrix
    int claim[5][3] = { { 5, 5, 3 },
                      { 4, 2, 2 },
                      { 8, 0, 2 },
                      { 2, 2, 2 },
                      { 4, 3, 3 } };

    // Initialize allocation matrix
    int alloc[5][3] = { { 0, 1, 0 },
                        { 2, 0, 0 },
                        { 3, 0, 2 },
                        { 2, 1, 1 },
                        { 0, 0, 2 } };

    // Initialize available matrix
    int avail[3] = { 3, 3, 2 };

    int f[n], ans[n], ind = 0;
    for (k = 0; k < n; k++) {
        f[k] = 0;
    }

    // Initialize need matrix
    int need[n][m];
    for (i = 0; i < n; i++) {
        for (j = 0; j < m; j++){
            need[i][j] = claim[i][j] - alloc[i][j];
        }
    }

    // Print initial matrices
    printf("Initial matrices\n");
    printf("Claim\t\tAllocation\tNeed\n");
    printf("   R1 R2 R3\t   R1 R2 R3\t   R1 R2 R3\n");

    for(i=0;i<n;i++){

        printf("P%d|", i);
        for(j=0;j<m;j++){
            printf("%2d ", claim[i][j]);
        }

        printf("\tP%d|", i);
        for(j=0;j<m;j++){
            printf("%2d ", alloc[i][j]);
        }

        printf("\tP%d|", i);
        for(j=0;j<m;j++){
            printf("%2d ", need[i][j]);
        }

        printf("\n");
    }

    printf("Available | ");
    for(i=0;i<m;i++){
        printf("%d ", avail[i]);
    }
    printf("|\n=============================================");

    int y = 0;

    // Modification of Iteration Process
    for (k = 0; k < n; k++) {
        int max_alloc = -1;
        int max_index = -1;
        for (i = 0; i < n; i++) {
            if (f[i] == 0) {

                int flag = 0;
                for (j = 0; j < m; j++) {
                    if (need[i][j] > avail[j]) {
                        flag = 1;
                        break;
                    }
                }

                if (flag == 0) {
                    if (alloc[i][0] + alloc[i][1] + alloc[i][2] > max_alloc) {
                        max_alloc = alloc[i][0] + alloc[i][1] + alloc[i][2];
                        max_index = i;
                    }
                }
            }
        }

        if (max_index != -1) {
            ans[ind++] = max_index + 1;

            for (y = 0; y < m; y++){
                avail[y] += alloc[max_index][y];
                alloc[max_index][y] -= alloc[max_index][y];
                need[max_index][y] -= need[max_index][y];
            }

            f[max_index] = 1;
        }

        printf("\n\nITERATION %d:\n", k+1);
        printf("Claim\t\tAllocation\tNeed\n");
        printf("   R1 R2 R3\t   R1 R2 R3\t   R1 R2 R3\n");

        for(i=0;i<n;i++){
            printf("P%d|", i);
            for(j=0;j<m;j++){
                printf("%2d ", claim[i][j]);
            }

            printf("\tP%d|", i);
            for(j=0;j<m;j++){
                printf("%2d ", alloc[i][j]);
            }

            printf("\tP%d|", i);
            for(j=0;j<m;j++){
                printf("%2d ", need[i][j]);
            }

            printf("\n");
        }

        printf("Available | ");
        for(i=0;i<m;i++){
            printf("%d ", avail[i]);
        }
        printf("|\n\n---------------------------------------------");
    }

    int flag = 1;
    for (int i = 0; i < n; i++) {
        if (f[i] == 0) {
            flag = 0;
            printf("\n\nThe system is not safe.\n");
            break;
        }
    }

    if (flag == 1) {
        printf("\n\nSequence:");

        for (i = 0; i < n - 1; i++)
            printf(" P%d ->", ans[i]);

        printf(" P%d\n", ans[n - 1]);
    }

    return (0);
}