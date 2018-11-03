package main

import (
    "fmt"
    "flag"
//    "bufio"
//    "os"
//    "strings"
    "strconv"
//    "time"
//    "sync"
)

type Matrix struct {
    s1   string;
    s2   string;
    vals [][]int;
}

func createMatrix(s1 string, s2 string) *Matrix {
    vals := make([][]int, len(s1) + 1);
    for i := 0; i < len(s1) +1; i += 1 {
        vals[i] = make([]int, len(s2) + 1);
    }
    for i := 0; i < len(s1) + 1; i += 1 {
        vals[i][0] = -i
    }
    for i := 0; i < len(s2) + 1; i += 1 {
        vals[0][i] = -i
    }
    return &Matrix{ s1, s2, vals};
}

func (this Matrix) String() string {
    result := ",,"
    for i := 0; i < len(this.s2); i += 1 {
        result += string(this.s2[i]) + ","
    }
    result += "\n"
    w1 := "," + this.s1
    for i := 0; i < len(w1); i += 1 {
        result += string(w1[i]) + " , "
        for j := 0; j < len(this.s2) + 1; j += 1 {
            result += strconv.Itoa(this.vals[i][j]) + " , "
        }
        result += "\n";
    }
    return result
}

func max(a, b, c int) int {
    result := -999;
    if a > b {
        result = a
    } else {
        result = b
    }
    if c > result {
        result = c
    }
    return result
}

func (this *Matrix) fillUp() {
    for i := 1; i < len(this.s1) + 1; i += 1 {
        for j := 1; j < len(this.s2) + 1; j += 1 {
            local_store := 0
            if this.s1[i - 1] == this.s2[j - 1] {
                local_store = 1
            } else {
                local_store = -1
            }
            match := this.vals[i-1][j-1] + local_store
            s1forward := this.vals[i-1][j] - 1
            s2forward := this.vals[i][j-1] - 1
            this.vals[i][j] = max(match, s1forward, s2forward)
        }
    }
}

func main() {
    arg1 := flag.String("s1", "", "First string")
    arg2 := flag.String("s2", "", "Second string")
    flag.Parse()
    s1 := *arg1
    s2 := *arg2
    matrix := createMatrix(s1, s2);
    matrix.fillUp();
    fmt.Println(matrix);
    //r1, r2 := extractVals(matrix)
    //fmt.Println(matrix)
    //fmt.Println(r1)
    //fmt.Println(r2)
}
