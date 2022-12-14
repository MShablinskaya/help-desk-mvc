package com.innowise.training.shablinskaya.helpdesk.service.impl;

import com.innowise.training.shablinskaya.helpdesk.converter.TicketConverter;
import com.innowise.training.shablinskaya.helpdesk.converter.UserConverter;
import com.innowise.training.shablinskaya.helpdesk.converter.impl.AttachmentDtoConverter;
import com.innowise.training.shablinskaya.helpdesk.dto.AttachmentDto;
import com.innowise.training.shablinskaya.helpdesk.dto.TicketDto;
import com.innowise.training.shablinskaya.helpdesk.entity.Attachment;
import com.innowise.training.shablinskaya.helpdesk.exception.TicketStateException;
import com.innowise.training.shablinskaya.helpdesk.repository.AttachmentRepository;
import com.innowise.training.shablinskaya.helpdesk.service.AttachmentService;
import com.innowise.training.shablinskaya.helpdesk.service.HistoryService;
import com.innowise.training.shablinskaya.helpdesk.service.TicketService;
import com.innowise.training.shablinskaya.helpdesk.service.UserService;
import org.apache.commons.io.FilenameUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.persistence.EntityNotFoundException;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Service
public class AttachmentServiceImpl implements AttachmentService {
    private final static int MAX_FILE_SIZE = 5000000;
    private final static String WRONG_SELECTED_TYPE = "The selected file type is not allowed. Please select a file of one of the following types: pdf, png, doc, docx, jpg, jpeg.";
    private final static String WRONG_SIZE = "The size of attached file should not be greater than 5 Mb. Please select another file.";

    private final AttachmentRepository attachmentRepository;
    private final AttachmentDtoConverter converter;
    private final TicketConverter ticketConverter;
    private final TicketService ticketService;
    private final UserService userService;
    private final UserConverter userConverter;
    private final HistoryService historyService;


    public AttachmentServiceImpl(AttachmentRepository attachmentRepository,
                                 AttachmentDtoConverter converter,
                                 TicketConverter ticketConverter,
                                 TicketService ticketService,
                                 UserService userService,
                                 UserConverter userConverter,
                                 HistoryService historyService) {
        this.attachmentRepository = attachmentRepository;
        this.converter = converter;
        this.ticketConverter = ticketConverter;
        this.ticketService = ticketService;
        this.userService = userService;
        this.userConverter = userConverter;
        this.historyService = historyService;
    }

    @Override
    @Transactional
    public List<AttachmentDto> multipleUploadFile(Long id, MultipartFile[] files){
        TicketDto dto = ticketService.findById(id);
        List<AttachmentDto> attachmentDtoList = new ArrayList<>();

        Arrays.stream(files).forEach(file -> {
            Attachment fileForUpload;
            try{
                fileForUpload = uploadFile(dto, file);
                attachmentDtoList.add(converter.toDto(fileForUpload));
            } catch (TicketStateException | IOException e) {
                e.printStackTrace();
            }
        });
    return attachmentDtoList;
    }


    @Override
    @Transactional
    public void deleteFile(Long id) throws TicketStateException {
        AttachmentDto dto = findById(id);
        removeFile(dto);
    }

    @Override
    @Transactional
    public Attachment uploadFile(TicketDto ticketDto, MultipartFile file) throws IOException, TicketStateException {
        if (ticketDto != null
                && file != null
                && ticketDto.getOwner().equals(userConverter.toDto(userService.getCurrentUser()))) {
            if (file.getSize() <= MAX_FILE_SIZE) {
                String type = FilenameUtils.getExtension(file.getOriginalFilename());
                if (allowedFileTypes(type)) {
                    Attachment attachment = new Attachment();
                    attachment.setName(file.getOriginalFilename());
                    attachment.setTicket(ticketConverter.toUpdEntity(ticketDto));
                    attachment.setAttachment(file.getBytes());

                    historyService.recordHistoryForUploadedAttachment(converter.toDto(attachment), attachment.getTicket());
                    return attachmentRepository.save(attachment);
                } else {
                    throw new TicketStateException(WRONG_SELECTED_TYPE);
                }
            } else {
                throw new TicketStateException(WRONG_SIZE);
            }
        } else {
            throw new TicketStateException("Ticket not fount!");
        }

    }

    @Override
    @Transactional
    public void removeFile(AttachmentDto dto) throws TicketStateException {
        if (dto != null) {
            TicketDto ticketDto = ticketService.findById(dto.getTicketId());
            if (ticketDto.getOwner().equals(userConverter.toDto(userService.getCurrentUser()))) {
                attachmentRepository.remove(attachmentRepository.getById(dto.getId()).orElseThrow(EntityNotFoundException::new));
                historyService.recordHistoryForDeletedAttachment(dto, ticketConverter.toUpdEntity(ticketDto));
            } else {
                throw new TicketStateException("You don't have permission to delete this Attachment");
            }
        } else {
            throw new TicketStateException("File doesn't exist!");
        }
    }

    @Override
    public List<AttachmentDto> getAttachmentsByTicketId(Long ticketId) throws TicketStateException {
        if (ticketId != null){
            List<Attachment> attachments = attachmentRepository.getByTicketId(ticketId);

            List<AttachmentDto> dtos = new ArrayList<>();
            if(attachments != null){
                attachments.forEach(attachment -> dtos.add(converter.toDto(attachment))); }
            return dtos;
        }else{
            throw new TicketStateException("Ticket ID is can't be NULL!");
        }

    }

    private AttachmentDto findById(Long id) {
        return converter.toDto(attachmentRepository.getById(id).orElseThrow(EntityNotFoundException::new));
    }

    private boolean allowedFileTypes(String type) {
        List<String> allowed = new ArrayList<>();

        allowed.add("pdf");
        allowed.add("doc");
        allowed.add("docx");
        allowed.add("png");
        allowed.add("jpeg");
        allowed.add("jpg");

        return allowed.contains(type);
    }
}
