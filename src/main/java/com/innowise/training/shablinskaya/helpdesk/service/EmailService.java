package com.innowise.training.shablinskaya.helpdesk.service;

import com.innowise.training.shablinskaya.helpdesk.dto.TicketDto;


public interface EmailService {

    void sendAllManagerMessage(TicketDto dto);

    void sendAllEngineerMessage(TicketDto dto);

    void sendCreatorMessage(TicketDto dto);

    void sendEmailsForNewTickets(TicketDto dto);

    void sendApproveMessage(TicketDto dto);

    void sendAssigneeMessage(TicketDto dto);

}
