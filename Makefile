NAME= inception

SRCS= ./srcs
COMPOSE= $(SRCS)/docker-compose.yml
HOST_URL= dgomez-a.42.fr
RM= rm -rf

all:

clean:

fclean: clean

re: fclean all

.PHONY: all clean fclean re
