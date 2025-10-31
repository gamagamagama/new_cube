/******************************************************************************/
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strrtrim.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: mgavornik <mgavornik@student.42.fr>        +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/07 11:33:38 by vnicoles          #+#    #+#             */
/*   Updated: 2025/10/28 00:05:53 by mgavornik        ###   ########.fr       */
/*                                                                            */
/******************************************************************************/

#include "../inc/libft.h"

char	*ft_strrtrim(const char *s, const char *set)
{
	size_t	end;

	if (!s)
		return (NULL);
	end = ft_strlen(s);
	while (end > 0 && ft_strchr(set, s[end - 1]))
		end--;
	return (ft_substr(s, 0, end));
}
