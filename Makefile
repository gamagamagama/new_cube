#******************************************************************************#
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mgavornik <mgavornik@student.42.fr>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/08/20 18:29:20 by vnicoles          #+#    #+#              #
#    Updated: 2025/10/31 19:54:32 by mgavornik        ###   ########.fr        #
#                                                                              #
#******************************************************************************#

# --- Colors ---
PURPLE	= \033[38;5;141m
GREEN	= \033[38;5;46m
RED		= \033[0;31m
GREY	= \033[38;5;240m
RESET	= \033[0m
BOLD	= \033[1m
YELLOW	= \033[33m
CLEAR	= \r\033[K

# --- Vars ---
NAME		= cub3d
CC			= cc -std=gnu11 -g
CFLAGS		= -Wall -Wextra -Werror

# --- Paths ---
MLX_REPO	= https://github.com/gamagamagama/minilibx-linux.git
MLX_DIR		= $(LIB_DIR)/mlx

SRC_DIR		= src
LIB_DIR		= lib
LIBFT_DIR	= $(LIB_DIR)/libft
OBJ_DIR		= obj
INC_DIR		= inc
INC			= -I inc/ -I lib/libft/inc/ -I lib/mlx/

# --- Source Files ---
SRC			= src/main.c \
			  src/init.c \
			  src/init/init_data0.c\
			  src/init/init_radar_data.c\
			  src/utils.c \
			  src/wtf_utils.c \
			  src/draw/shapes.c \
			  src/radar/radar_utils.c \
			  src/radar/radar_mod.c \
			  src/radar/radar_col_side.c \
			  src/radar/radar_col_diag.c \
			  src/radar/radar_col_proc.c \
			  src/parsing/cub_data.c \
			  src/parsing/colors.c \
			  src/parsing/textures.c \
			  src/parsing/map_line.c \
			  src/parsing/utils.c \
			  src/parsing/map_validation/map.c \
			  src/parsing/map_validation/player_direct.c \
			  src/parsing/map_validation/map_line.c \
			  src/parsing/map_validation/map_store.c \
			  src/raycasting/ray_init.c \
			  src/raycasting/cast_ray.c \
			  src/render/draw_shade.c \
			  src/render/draw_column.c \
			  src/render/helpers.c \
			  src/player.c \
			  src/utils/fps_counter.c \
			  src/utils/exit_err.c \
			  src/utils/vectors.c \
			  src/exit/free.c \
			  src/exit/exit.c
			  

OBJ			= $(addprefix $(OBJ_DIR)/, $(SRC:.c=.o))

# Alternative approaches (commented out):
# SRC := $(shell find $(SRC_DIR) -name "*.c")
# OBJ := $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRC))
# SRC := $(wildcard $(SRC_DIR)/**/*.c)
# OBJ := $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRC))

# --- Libs ---
LIBFT		= $(LIB_DIR)/libft/libft.a
MLX			= $(LIB_DIR)/mlx/libmlx_Linux.a
LIBS		= $(LIBFT) $(MLX) -L$(MLX_DIR) -lmlx -lXext -lX11 -lm -lz

# --- Progress bar ---
TOTAL_FILES	= $(words $(SRC))
CURR_FILE	= 0

define update_progress
	@$(eval CURR_FILE = $(shell echo "$(CURR_FILE) + 1" | bc -l))
	@$(eval PERCENT = $(shell echo "$(CURR_FILE) * 100 / $(TOTAL_FILES)" | bc -l | cut -d. -f1))
	@printf "\r\033[K"
	@printf "$(GREEN)»$(RESET) [$(PURPLE)$(BOLD)$(NAME)$(RESET)]: \tCompiling... ["
	@printf "%*s" $(shell echo "$(PERCENT) * 20 / 100" | bc -l | cut -d. -f1) "" | tr ' ' '='
	@printf "%*s" $(shell echo "20 - ($(PERCENT) * 20 / 100)" | bc -l | cut -d. -f1) "" | tr ' ' '.'
	@printf "] %3d%% %s" $(PERCENT)
	@printf " %s" $(notdir $<)
endef

# --- Rules ---
all: clone $(NAME)

clone:
	@if [ ! -d "$(MLX_DIR)" ]; then \
		echo -e "$(GREEN)»$(RESET) [$(PURPLE)$(BOLD)MLX$(RESET)]: \t$(GREEN)Cloning MLX into $(MLX_DIR)...$(RESET)"; \
		git clone $(MLX_REPO) $(MLX_DIR); \
	else \
		echo -e "$(GREEN)»$(RESET) [$(PURPLE)$(BOLD)MLX$(RESET)]: \t$(YELLOW)MLX already cloned.$(RESET) "; \
	fi


$(NAME): $(LIBFT) $(MLX) $(OBJ)
	@echo -e "\n$(GREEN)»$(RESET) [$(PURPLE)$(BOLD)$(NAME)$(RESET)]: \tLinking..."
	@$(CC) $(CFLAGS) $(OBJ) $(INC) -o $(NAME) $(LIBS)
	@echo -e "$(GREEN)»$(RESET) [$(PURPLE)$(BOLD)$(NAME)$(RESET)]: \t$(GREEN)Build complete!$(RESET)"

$(LIBFT):
	@echo -e "$(GREEN)»$(RESET) [$(PURPLE)$(BOLD)libft$(RESET)]: \tBuilding libft..."
	@make -C $(LIBFT_DIR)

$(MLX): clone
	@echo -e "$(GREEN)»$(RESET) [$(PURPLE)$(BOLD)MLX$(RESET)]: \tBuilding MLX..."
	@make -C $(MLX_DIR)

# Create object directory if it doesn't exist
$(OBJ_DIR):
	@mkdir -p $(OBJ_DIR)
	@mkdir -p $(OBJ_DIR)/$(SRC_DIR)

# Fixed object file compilation rule
$(OBJ_DIR)/%.o: %.c | $(OBJ_DIR)
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) $(INC) -c $< -o $@
	$(call update_progress)



clean:
	@rm -rf $(OBJ_DIR)
	@make clean -C $(LIBFT_DIR) 2>/dev/null || true
	@make clean -C $(MLX_DIR) 2>/dev/null || true
	@echo -e "$(GREEN)»$(RESET) [$(PURPLE)$(BOLD)$(NAME)$(RESET)]: \tCleaned object files"

fclean: clean
	@rm -f $(NAME)
	@make fclean -C $(LIBFT_DIR) 2>/dev/null || true
	@if [ -d "$(MLX_DIR)" ]; then \
		echo -e "$(GREEN)»$(RESET) [$(PURPLE)$(BOLD)MLX$(RESET)]: \t$(YELLOW)Removing cloned MLX repo...$(RESET)"; \
		rm -rf $(MLX_DIR); \
	else \
		echo -e "$(GREEN)»$(RESET) [$(PURPLE)$(BOLD)MLX$(RESET)]: \t$(GREEN)MLX not cloned.$(RESET) "; \
	fi
	@echo -e "$(GREEN)»$(RESET) [$(PURPLE)$(BOLD)$(NAME)$(RESET)]: \t$(GREEN)Full clean$(RESET)"


re: fclean all

# Show help
help:
	@echo -e "$(BOLD)Available targets:$(RESET)\n"
	@echo -e "  $(GREEN)all$(RESET)     - Build the project\n"
	@echo -e "  $(GREEN)clean$(RESET)   - Remove object files\n"
	@echo -e "  $(GREEN)fclean$(RESET)  - Remove all generated files\n"
	@echo -e "  $(GREEN)re$(RESET)      - Rebuild everything\n"
	@echo -e "  $(GREEN)help$(RESET)    - Show this help\n"

.PHONY: all clean fclean re help
