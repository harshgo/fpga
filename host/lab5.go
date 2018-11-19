package main

import (
	"flag"
	"fmt"
	//    "bufio"
	//    "os"
	//    "strings"
	"strconv"
	//    "time"
	//    "sync"
)

type Matrix struct {
	s1   string
	s2   string
	vals [][]int
	prev [][]int
}

func createMatrix(s1 string, s2 string) *Matrix {
	vals := make([][]int, len(s1)+1)
	prev := make([][]int, len(s1)+1)
	for i := 0; i < len(s1)+1; i += 1 {
		prev[i] = make([]int, len(s2)+1)
	}
	for i := 0; i < len(s1)+1; i += 1 {
		vals[i] = make([]int, len(s2)+1)
	}
	for i := 0; i < len(s1)+1; i += 1 {
		vals[i][0] = -i
		prev[i][0] = 1
	}
	for i := 0; i < len(s2)+1; i += 1 {
		vals[0][i] = -i
		prev[0][i] = 2
	}
	return &Matrix{s1, s2, vals, prev}
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
		for j := 0; j < len(this.s2)+1; j += 1 {
			result += strconv.Itoa(this.vals[i][j]) + " , "
		}
		result += "\n"
	}
	for i := 0; i < len(w1); i += 1 {
		for j := 0; j < len(this.s2)+1; j += 1 {
			result += strconv.Itoa(this.prev[i][j]) + " "
		}
		result += "\n"
	}
	return result
}

func max(a, b, c int) (int, int) {
	result := -999
	ind := 0
	if a > b {
		result = a
		ind = 0
	} else {
		result = b
		ind = 1
	}
	if c > result {
		result = c
		ind = 2
	}
	return ind, result
}

func (this *Matrix) fillUp() {
	for i := 1; i < len(this.s1)+1; i += 1 {
		for j := 1; j < len(this.s2)+1; j += 1 {
			local_store := 0
			if this.s1[i-1] == this.s2[j-1] {
				local_store = 1
			} else {
				local_store = -1
			}
			match := this.vals[i-1][j-1] + local_store
			s1forward := this.vals[i-1][j] - 1
			s2forward := this.vals[i][j-1] - 1
			ind, v := max(match, s1forward, s2forward)
			this.vals[i][j] = v
			this.prev[i][j] = ind
		}
	}
}

func prev2ind(prev, row, col int) (int, int) {
	if prev == 0 {
		return row - 1, col - 1
	} else if prev == 1 {
		return row - 1, col
	} else {
		return row, col - 1
	}
}

func (this *Matrix) extractVals() (string, string, int) {
	r1 := ""
	r2 := ""
	row := len(this.s1)
	col := len(this.s2)
	res := this.vals[row-1][col-1]
	for row != 0 || col != 0 {
		prev := this.prev[row][col]
		n_row, n_col := prev2ind(prev, row, col)
		if row == n_row {
			r1 = "-" + r1
		} else {
			r1 = string(this.s1[n_row]) + r1
		}
		if col == n_col {
			r2 = "-" + r2
		} else {
			r2 = string(this.s2[n_col]) + r2
		}
		row, col = n_row, n_col
	}
	return r1, r2, res
}

func main() {
	arg1 := flag.String("s1", "", "First string")
	arg2 := flag.String("s2", "", "Second string")
	flag.Parse()
	s1 := *arg1
	s2 := *arg2
	matrix := createMatrix(s1, s2)
	matrix.fillUp()
	fmt.Println(matrix)
	// fmt.Println(matrix)
	r1, r2, v := matrix.extractVals()
	fmt.Println(r1)
	fmt.Println(r2)
	fmt.Println(v)
}
