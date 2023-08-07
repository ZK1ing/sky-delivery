package com.sky.service;

import com.sky.dto.OrdersSubmitDTO;
import com.sky.result.PageResult;
import com.sky.vo.OrderSubmitVO;
import com.sky.vo.OrderVO;

public interface OrderService {
    /**
     * 用户下单
     */
    OrderSubmitVO sumbitOrder(OrdersSubmitDTO ordersSubmitDTO);

    PageResult pageQueryUser(int page, int pageSize, Integer status);

    OrderVO detail(Long id);

    void repetition(Long id);

//    void userCancelById(Long id);
}
