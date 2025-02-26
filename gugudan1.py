# 구구단 출력 프로그램
def print_multiplication_table():
    print("===== 구구단 =====")
    for i in range(2, 10):  # 2단부터 9단까지
        print(f"==== {i}단 ====")
        for j in range(1, 10):  # 1부터 9까지 곱하기
            print(f"{i} x {j} = {i*j}")
        print()  # 각 단 사이에 빈 줄 출력

# 함수 호출
print_multiplication_table()