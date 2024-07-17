 # Makefile

  - name: Set output # replace with writing to GITHUB_OUTPUT
    run: echo "hello" >> $GITHUB_OUTPUT

  test:
    make -j test # parallelize

  .PHONY: test
  test: test-rust test-go test-python # separate targets
